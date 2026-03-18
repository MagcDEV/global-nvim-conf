return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig_util = require("lspconfig.util")
		local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
		local sep = is_windows and "\\" or "/"
		local mason_packages = vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "packages"
		local lua_ls_cmd = is_windows
			and mason_packages .. sep .. "lua-language-server" .. sep .. "bin" .. sep .. "lua-language-server.exe"
			or mason_packages .. sep .. "lua-language-server" .. sep .. "bin" .. sep .. "lua-language-server"

		-- Use new vim.lsp.config API (Neovim 0.11+)
		vim.lsp.config = vim.lsp.config or {}

		vim.lsp.config.lua_ls = {
			cmd = { lua_ls_cmd },
			capabilities = capabilities,
		}

		vim.lsp.config.clangd = {
			cmd = {
				"C:/msys64/ucrt64/bin/clangd.exe",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--log=verbose",
				"--query-driver=C:/msys64/ucrt64/bin/clang*.exe;C:/msys64/ucrt64/bin/gcc*.exe",
				"--compile-commands-dir=build",
			},
			init_options = {
				compilationDatabasePath = "build",
				fallbackFlags = {
					"-std=c++17",
					"--target=x86_64-w64-windows-gnu",
					"-I",
					"C:/msys64/ucrt64/include",
				},
			},
			capabilities = capabilities,
		}

		vim.lsp.config.gopls = {
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = lspconfig_util.root_pattern("go.work", "go.mod", ".git"),
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					completeUnimported = true,
					gofumpt = true,
					staticcheck = true,
					usePlaceholders = true,
				},
			},
		}

		local function ensure_start(patterns, name)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = patterns,
				callback = function()
					if #vim.lsp.get_clients({ bufnr = 0, name = name }) == 0 then
						local cfg = vim.tbl_deep_extend("force", { name = name }, vim.lsp.config[name] or {})
						vim.lsp.start(cfg)
					end
				end,
			})
		end

		ensure_start({ "lua" }, "lua_ls")
		ensure_start({ "c", "cpp", "objc", "objcpp" }, "clangd")
		ensure_start({ "go", "gomod", "gowork", "gotmpl" }, "gopls")
		-- C# handled by roslyn.nvim

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			end,
		})
	end,
}
