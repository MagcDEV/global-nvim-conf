return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				go = { "goimports", "gofumpt" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = function(bufnr)
				if vim.bo[bufnr].filetype == "go" then
					return
				end
			end,
			format_after_save = function(bufnr)
				if vim.bo[bufnr].filetype ~= "go" then
					return
				end

				return {
					timeout_ms = 5000,
					lsp_format = "fallback",
				}
			end,
			notify_on_error = true,
		},
	},
}
