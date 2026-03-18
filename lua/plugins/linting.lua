return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			local golangcilint = lint.linters.golangcilint
			local function golangcilint_args()
				local ok, version_info = pcall(vim.fn.system, { "golangci-lint", "version" })
				if not ok then
					return {}
				end

				local filename_modifier = ":h"
				local gomod_ok, go_mod_location = pcall(vim.fn.system, { "go", "env", "GOMOD" })
				if not gomod_ok then
					filename_modifier = ":p"
				else
					go_mod_location = go_mod_location:gsub("%s+", "")
					if go_mod_location == "" or go_mod_location == "/dev/null" or go_mod_location:upper() == "NUL" then
						filename_modifier = ":p"
					end
				end

				if string.find(version_info, "version v1") or string.find(version_info, "version 1") then
					return {
						"run",
						"--out-format",
						"json",
						"--issues-exit-code=0",
						"--show-stats=false",
						"--print-issued-lines=false",
						"--print-linter-name=false",
						function()
							return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), filename_modifier)
						end,
					}
				end

				local args = {
					"run",
					"--output.json.path=stdout",
					"--output.text.path=",
					"--output.tab.path=",
					"--output.html.path=",
					"--output.checkstyle.path=",
					"--output.code-climate.path=",
					"--output.junit-xml.path=",
					"--output.teamcity.path=",
					"--output.sarif.path=",
					"--issues-exit-code=0",
					"--show-stats=false",
				}

				if not string.find(version_info, "version v2.0.") and not string.find(version_info, "version 2.0.") then
					table.insert(args, "--path-mode=abs")
				end

				table.insert(args, function()
					return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), filename_modifier)
				end)

				return args
			end

			if golangcilint then
				golangcilint.ignore_exitcode = true
				golangcilint.args = golangcilint_args()
			end

			lint.linters_by_ft = {
				go = { "golangcilint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					if vim.bo.filetype == "go" then
						if golangcilint then
							golangcilint.args = golangcilint_args()
						end
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
