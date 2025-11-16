return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Use new vim.lsp.config API (Neovim 0.11+)
		vim.lsp.config = vim.lsp.config or {}

		vim.lsp.config.lua_ls = {
			cmd = {
				"C:\\Users\\vhzn\\AppData\\Local\\nvim-data\\mason\\packages\\lua-language-server\\bin\\lua-language-server.exe",
			},
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
