-- Leader keys must be set before lazy loads
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Editor settings
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
vim.opt.termguicolors = true
vim.opt.shadafile = "NONE"
vim.opt.clipboard = "unnamedplus"

require("config.lazy")

vim.cmd.colorscheme("tokyonight-storm")

local function apply_code_highlights()
	vim.api.nvim_set_hl(0, "@function", { fg = "#7aa2f7", bold = true })
	vim.api.nvim_set_hl(0, "@function.method", { fg = "#7aa2f7" })
	vim.api.nvim_set_hl(0, "@function.call", { fg = "#7aa2f7" })
	vim.api.nvim_set_hl(0, "@function.method.call", { fg = "#7aa2f7" })
	vim.api.nvim_set_hl(0, "@constructor", { fg = "#7dcfff" })
	vim.api.nvim_set_hl(0, "@type", { fg = "#7dcfff" })
	vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#2ac3de" })
	vim.api.nvim_set_hl(0, "@module", { fg = "#bb9af7" })
	vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#e0af68", italic = true })
	vim.api.nvim_set_hl(0, "@variable.member", { fg = "#9ece6a" })

	vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "@function" })
	vim.api.nvim_set_hl(0, "@lsp.type.method", { link = "@function.method" })
	vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "@variable.parameter" })
	vim.api.nvim_set_hl(0, "@lsp.type.type", { link = "@type" })
	vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "@module" })
	vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@variable.member" })

	vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#f7768e" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#e0af68" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#7aa2f7" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#ff9e64" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#9ece6a" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#bb9af7" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#7dcfff" })
end

apply_code_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_code_highlights,
})

-- Background transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })

-- Line number color
vim.api.nvim_set_hl(0, "LineNr", { fg = "#403e3c" })

-- Diagnostics
vim.keymap.set("n", "<leader>q", ":lua vim.diagnostic.open_float()<CR>", {})

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Tab navigation
vim.keymap.set("n", "<F7>", ":tabn<CR>", {})
vim.keymap.set("n", "<F8>", ":tabp<CR>", {})

-- File navigation
vim.keymap.set("n", "<leader>e", ":Ex<CR>", {})

-- Terminal escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
