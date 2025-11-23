vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.cmd("set nobackup")
vim.cmd("set nowritebackup")
vim.cmd("set noswapfile")
vim.cmd("set rnu")
vim.cmd("set cursorline")
vim.opt.shadafile = "NONE"

-- Cursor configuration for better visibility
vim.opt.termguicolors = true
vim.cmd("set cursorline")
vim.cmd("set termguicolors")
require("config.lazy")

--require("catppuccin").setup()
--vim.cmd.colorscheme("flexoki-dark")
vim.cmd.colorscheme("tokyonight-storm")
-- Set the background transparency for Neovim
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })

-- Set keymap to float windows with error and warnings
vim.keymap.set("n", "<leader>q", ":lua vim.diagnostic.open_float()<CR>", {})

-- Set keymap to toggle copilot chat
vim.keymap.set("n", "<leader>cc", ":CopilotChatToggle<CR>", {})

-- Set the font color of line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = "#403e3c" })

-- Set cursor colors for better visibility with dark theme
--vim.api.nvim_set_hl(0, "Cursor", { fg = "#1a1b26", bg = "#c0caf5" })  -- Bright cursor
--vim.api.nvim_set_hl(0, "lCursor", { fg = "#1a1b26", bg = "#c0caf5" }) -- Language mapping cursor
--vim.api.nvim_set_hl(0, "TermCursor", { fg = "#1a1b26", bg = "#c0caf5" }) -- Terminal cursor
--vim.api.nvim_set_hl(0, "TermCursorNC", { fg = "#1a1b26", bg = "#7aa2f7" }) -- Terminal cursor (not focused)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
-- map :tabn and :tabp to F7 and F8
vim.keymap.set("n", "<F7>", ":tabn<CR>", {})
vim.keymap.set("n", "<F8>", ":tabp<CR>", {})

-- file navigation
vim.keymap.set("n", "<leader>e", ":Ex<CR>", {})

-- easier terminal mode escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})

-- here the configuration for dap ####################################################
local dap = require("dap")
local dapui = require("dapui")

-- Initialize DAP UI first
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
		{ id = "scopes", size = 0.25 },
		{ id = "breakpoints", size = 0.25 },
		{ id = "stacks", size = 0.25 },
		{ id = "watches", size = 0.25 },
		{ id = "console", size = 0.25 },
		{ id = "repl", size = 0.5 },
	},
})

dap.set_log_level("DEBUG")
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
			local dll_path = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/net8.0/*.dll")
			return dll_path
		end,
		cwd = "${workspaceFolder}",
		env = {
			ASPNETCORE_ENVIRONMENT = "Development",
			ASPNETCORE_URLS = "https://localhost:5001;http://localhost:5000",
		},
		console = "integratedTerminal",
		stopAtEntry = true, -- Add this line
		justMyCode = false, -- Add this line
	},
	{
		type = "coreclr",
		name = "Attach to process",
		request = "attach",
		processId = require("dap.utils").pick_process,
		justMyCode = false,
	},
}

-- Detect OS
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local sep = is_windows and "\\" or "/"

-- C++ configuration using cpptools (Microsoft C++ debugger)
dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = is_windows
		and vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "packages" .. sep .. "cpptools" .. sep .. "extension" .. sep .. "debugAdapters" .. sep .. "bin" .. sep .. "OpenDebugAD7.exe"
		or vim.fn.stdpath("data") .. sep .. "mason" .. sep .. "packages" .. sep .. "cpptools" .. sep .. "extension" .. sep .. "debugAdapters" .. sep .. "bin" .. sep .. "OpenDebugAD7",
	options = {
		detached = false,
	},
}

-- C++ configuration using CodeLLDB
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

-- Function to get the directory of current file
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
		cwd = function()
			return get_source_dir()
		end,
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
		cwd = function()
			return get_source_dir()
		end,
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

-- Modified listeners with vim.schedule
dap.listeners.after.event_initialized["dapui_config"] = function()
	vim.schedule(dapui.open)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	-- Don't auto-close on terminate, let user close manually
end
dap.listeners.before.event_exited["dapui_config"] = function()
	-- Don't auto-close on exit, let user close manually
end

-- Basic controls
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<leader>b", function()
	require("dap").toggle_breakpoint()
end)

vim.keymap.set({ "n", "v" }, "<M-e>", function()
	require("dapui").eval()
end)

-- Advanced breakpoints
vim.keymap.set("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)

-- Open DAP REPL to see errors
vim.keymap.set("n", "<leader>dr", function()
	require("dap").repl.open()
end)

-- Terminate and close debugger
vim.keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
	require("dapui").close()
end)

vim.fn.sign_define("DapBreakpoint", {
	text = "🔴", -- Red dot symbol (or use 🔴/ for Nerd Font icons)
	texthl = "DapBreakpoint", -- Highlight group for the symbol
	linehl = "", -- Line highlight (optional)
	numhl = "", -- Number column highlight (optional)
})

-- Optional: Add conditional/logpoint variants
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })
