return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			-- This will be loaded first
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			-- Configuration moved to init.lua
		end,
	},
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "NicholasMata/nvim-dap-cs" },
}
