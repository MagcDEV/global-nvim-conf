return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.o.background = "dark"  -- switched to dark variant

    -- Dynamically choose contrast variant (soft/medium/hard)
    local function choose_background()
      if vim.env.EVERFOREST_BG and vim.env.EVERFOREST_BG ~= "" then
        return vim.env.EVERFOREST_BG
      end
      return "hard"  -- use darker (higher contrast) style by default
    end

    require("everforest").setup({
      background = choose_background(),      -- "soft", "medium", "hard"
      transparent_background_level = 0,      -- 0 (none), 1 (mild), 2 (more)
      italics = true,
      sign_column_background = "none",
      ui_contrast = "high",
      dim_inactive_windows = true,
      diagnostic_text_highlight = true,
      diagnostic_virtual_text = "colored",
      diagnostic_line_highlight = false,
      on_highlights = function(hl, c)
        hl.Comment.italic = true
        hl.LineNr = { fg = c.grey1 }
        hl.CursorLineNr = { fg = c.fg, bold = true }
      end,
    })

    --vim.cmd("colorscheme everforest")
  end,
}
