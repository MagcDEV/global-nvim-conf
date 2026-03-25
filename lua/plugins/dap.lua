return {
	{
		"mfussenegger/nvim-dap",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				controls = {
					element = "repl",
					enabled = true,
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						terminate = "⏹",
					},
				},
				elements = {
					{ id = "scopes",      size = 0.25 },
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks",      size = 0.25 },
					{ id = "watches",     size = 0.25 },
					{ id = "console",     size = 0.25 },
					{ id = "repl",        size = 0.5 },
				},
			})

			dap.set_log_level("DEBUG")

			-- Detect OS
			local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
			local sep = is_windows and "\\" or "/"

			-- C# / .NET Core (netcoredbg)
			dap.adapters.coreclr = {
				type = "executable",
				command = "C:\\netcoredbg\\netcoredbg.exe",
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch .NET Core App",
					request = "launch",
					program = function()
						return vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/net8.0/*.dll")
					end,
					cwd = "${workspaceFolder}",
					env = {
						ASPNETCORE_ENVIRONMENT = "Development",
						ASPNETCORE_URLS = "https://localhost:5001;http://localhost:5000",
					},
					console = "integratedTerminal",
					stopAtEntry = true,
					justMyCode = false,
				},
				{
					type = "coreclr",
					name = "Attach to process",
					request = "attach",
					processId = require("dap.utils").pick_process,
					justMyCode = false,
				},
			}

			-- C++ via cpptools (Microsoft debugger)
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = is_windows
					and vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "packages" .. sep .. "cpptools" .. sep .. "extension" .. sep .. "debugAdapters" .. sep .. "bin" .. sep .. "OpenDebugAD7.exe"
					or vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "packages" .. sep .. "cpptools" .. sep .. "extension" .. sep .. "debugAdapters" .. sep .. "bin" .. sep .. "OpenDebugAD7",
				options = { detached = false },
			}

			-- C++ via CodeLLDB
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = is_windows
						and vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "bin" .. sep .. "codelldb.cmd"
						or vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "bin" .. sep .. "codelldb",
					args = { "--port", "${port}" },
				},
			}

			local function get_source_dir()
				local file_path = vim.fn.expand("%:p:h")
				if file_path and file_path ~= "" then
					return file_path
				end
				return vim.fn.getcwd()
			end

			dap.configurations.cpp = {
				{
					name = "Launch C++ (cpptools)",
					type = "cppdbg",
					request = "launch",
					program = function()
						local source_dir = get_source_dir()
						local exe_name = is_windows and "hello.exe" or "hello"
						local exe_path = source_dir .. sep .. exe_name
						if vim.fn.filereadable(exe_path) == 1 then
							return exe_path
						end
						return vim.fn.input("Path to executable: ", source_dir .. sep, "file")
					end,
					cwd = function() return get_source_dir() end,
					stopAtEntry = true,
					MIMode = "gdb",
					miDebuggerPath = is_windows and "C:\\msys64\\ucrt64\\bin\\gdb.exe" or "/usr/bin/gdb",
					setupCommands = {
						{
							description = "Enable pretty-printing for gdb",
							text = "-enable-pretty-printing",
							ignoreFailures = true,
						},
					},
				},
				{
					name = "Launch C++ (codelldb)",
					type = "codelldb",
					request = "launch",
					program = function()
						local source_dir = get_source_dir()
						local exe_name = is_windows and "hello.exe" or "hello"
						local exe_path = source_dir .. sep .. exe_name
						if vim.fn.filereadable(exe_path) == 1 then
							return exe_path
						end
						return vim.fn.input("Path to executable: ", source_dir .. sep, "file")
					end,
					cwd = function() return get_source_dir() end,
					stopOnEntry = true,
				},
				{
					name = "Attach to process",
					type = "cppdbg",
					request = "attach",
					processId = require("dap.utils").pick_process,
					MIMode = "gdb",
					miDebuggerPath = is_windows and "C:\\msys64\\ucrt64\\bin\\gdb.exe" or "/usr/bin/gdb",
				},
			}

			dap.configurations.c = dap.configurations.cpp

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				vim.schedule(dapui.open)
			end
			dap.listeners.before.event_terminated["dapui_config"] = function() end
			dap.listeners.before.event_exited["dapui_config"] = function() end

			-- Breakpoint signs
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })

			-- Keymaps
			vim.keymap.set("n", "<F5>",       function() dap.continue() end)
			vim.keymap.set("n", "<F10>",      function() dap.step_over() end)
			vim.keymap.set("n", "<F11>",      function() dap.step_into() end)
			vim.keymap.set("n", "<F12>",      function() dap.step_out() end)
			vim.keymap.set("n", "<leader>b",  function() dap.toggle_breakpoint() end)
			vim.keymap.set("n", "<leader>B",  function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
			vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)
			vim.keymap.set("n", "<leader>dt", function() dap.terminate(); dapui.close() end)
			vim.keymap.set({ "n", "v" }, "<M-e>", function() dapui.eval() end)
		end,
	},
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "NicholasMata/nvim-dap-cs" },
}
