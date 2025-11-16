return {
    "m4xshen/autoclose.nvim",
    event = "VeryLazy",
    config = function()
        require("autoclose").setup({
            options = {
                disable_when_touch = true,
                disable_filetype = { "TelescopePrompt", "vim" },
                disable_in_macro = true,
                disable_in_visualblock = false,
            },
            mappings = {
                ["<CR>"] = { "<CR>", "Insert newline and close" },
                ["<C-l>"] = { "<C-l>", "Clear line and close" },
            },
        })
    end,
}
