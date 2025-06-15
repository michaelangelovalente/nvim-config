-- Java LSP Configuration

local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

-- Data directory - change to your preference
local home = os.getenv("HOME")
local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
local config_dir = jdtls_path .. "/config_linux"
local plugins_dir = jdtls_path .. "/plugins"
local path_to_jar = plugins_dir .. "/org.eclipse.equinox.launcher_*.jar"
local lombok_path = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    return
end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. "/.workspace/" .. project_name

-- Java debug and test libraries
local bundles = {}

-- Include java-debug if installed
local java_debug_path = home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server"
if vim.fn.isdirectory(java_debug_path) == 1 then
  local debug_glob = java_debug_path .. "/com.microsoft.java.debug.plugin-*.jar"
  local debug_bundles = vim.split(vim.fn.glob(debug_glob), "\n")
  if #debug_bundles > 0 then -- Only add if we found something
    vim.list_extend(bundles, debug_bundles)
  end
end

-- Include java-test if installed
local java_test_path = home .. "/.local/share/nvim/mason/packages/java-test/extension/server"
if vim.fn.isdirectory(java_test_path) == 1 then
  local test_glob = java_test_path .. "/*.jar"
  local test_bundles = vim.split(vim.fn.glob(test_glob), "\n")
  if #test_bundles > 0 then -- Only add if we found something
    vim.list_extend(bundles, test_bundles)
  end
end

-- LSP settings
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Improve completion experience
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Initialize init_options with or without bundles
local init_options
if #bundles > 0 then
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }
else
  init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
  }
end

-- Setup JDTLS
local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",

        -- Add lombok support if available
        "-javaagent:" .. lombok_path,

        "-jar", vim.fn.glob(path_to_jar),
        "-configuration", config_dir,
        "-data", workspace_dir,
    },
    root_dir = root_dir,
    settings = {
        java = {
            -- Enable enhanced documentation
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'javadoc' },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
                importOrder = {
                    "java",
                    "javax",
                    "com",
                    "org"
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = "/usr/lib/jvm/java-21-openjdk/",
                        default = true
                    },
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk/",
                    },
                    {
                        name = "JavaSE-11",
                        path = "/usr/lib/jvm/java-11-openjdk/",
                    }
                }
            },
        },
    },
    init_options = init_options,
    capabilities = capabilities,
    flags = {
        allow_incremental_sync = true,
    },
    on_attach = function(client, bufnr)
        -- Regular LSP keybindings (imported from your global setup)
        local function buf_set_keymap(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
        end

        -- Standard LSP keybindings
        buf_set_keymap('n', 'gD', vim.lsp.buf.declaration)
        buf_set_keymap('n', 'gd', vim.lsp.buf.definition)
        buf_set_keymap('n', 'K', vim.lsp.buf.hover)
        buf_set_keymap('n', 'gi', vim.lsp.buf.implementation)
        buf_set_keymap('n', '<C-k>', vim.lsp.buf.signature_help)
        buf_set_keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder)
        buf_set_keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder)
        buf_set_keymap('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
        buf_set_keymap('n', '<leader>D', vim.lsp.buf.type_definition)
        buf_set_keymap('n', '<leader>rn', vim.lsp.buf.rename)
        buf_set_keymap('n', '<leader>ca', vim.lsp.buf.code_action)
        buf_set_keymap('n', 'gr', vim.lsp.buf.references)
        buf_set_keymap('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)

        -- Java specific
        buf_set_keymap('n', '<leader>oi', jdtls.organize_imports)
        buf_set_keymap('n', '<leader>jc', jdtls.compile)

        -- Java documentation keybindings
        buf_set_keymap('n', '<leader>jd', function() vim.lsp.buf.hover() end) -- show documentation
        buf_set_keymap('n', '<leader>jD', function()
            -- Open current class javadoc in browser
            local fqn = jdtls.get_current_full_class_name()
            if fqn then
                -- Transform package.Class into package/Class.html
                local url = fqn:gsub("%.", "/") .. ".html"
                -- Construct command to open the URL
                local cmd = "xdg-open https://docs.oracle.com/en/java/javase/17/docs/api/" .. url
                os.execute(cmd)
            else
                print("Cannot find class name")
            end
        end)

        -- Code generation
        buf_set_keymap('n', '<leader>jg', jdtls.generate_to_string)
        buf_set_keymap('n', '<leader>je', jdtls.extract_variable)
        buf_set_keymap('v', '<leader>je', function() jdtls.extract_variable(true) end)
        buf_set_keymap('n', '<leader>jm', jdtls.extract_method)
        buf_set_keymap('v', '<leader>jm', function() jdtls.extract_method(true) end)
        buf_set_keymap('n', '<leader>jc', jdtls.extract_constant)

        -- If java-test is available
        if vim.fn.isdirectory(java_test_path) == 1 then
            buf_set_keymap('n', '<leader>jt', jdtls.test_class)
            buf_set_keymap('n', '<leader>jT', jdtls.test_nearest_method)
        end

        -- Enable formatting on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.java",
            callback = function()
                vim.lsp.buf.format({ async = false })
                -- Consider adding organize imports here too, but it can be slow
                -- jdtls.organize_imports()
            end,
            group = vim.api.nvim_create_augroup("JavaFormat", {})
        })

        -- Set specific java editor preferences
        local bo = vim.bo
        bo[bufnr].tabstop = 4
        bo[bufnr].softtabstop = 4
        bo[bufnr].shiftwidth = 4
        bo[bufnr].expandtab = true

        -- Highlight references on cursor hold
        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_augroup("java_highlight", { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = "java_highlight",
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = "java_highlight",
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end

        print("Java LSP started")
    end,
}

-- Automatically start jdtls for Java files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        jdtls.start_or_attach(config)
    end
})
