-- plugins/telescope.lua:
return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "%.lock",
            "%.jpg", "%.jpeg", "%.png", "%.gif", "%.webp", "%.svg",
            "%.otf", "%.ttf",
            "%.mp4", "%.mkv", "%.mp3", "%.ogg", "%.flac",
            "%.zip", "%.tar", "%.tar.gz", "%.rar", "%.7z",
            "%.exe", "%.dll", "%.bin", "%.obj", "%.o", "%.class", "%.pyc",
          },
          -- path_display = { "smart" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  }
}
