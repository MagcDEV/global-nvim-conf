# Neovim Configuration

A unified, cross-platform Neovim configuration designed to work seamlessly on both **Linux** and **Windows** systems.

## 🎯 Goals

- **Cross-platform compatibility**: Single configuration that works on both Linux and Windows
- **Modern IDE features**: LSP, debugging, autocompletion, and more
- **Optimized workflow**: Fast navigation, efficient keybindings, and productivity tools

## ✨ Features

- **Plugin Management**: [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and efficient plugin loading
- **Language Server Protocol (LSP)**: Integrated LSP support with nvim-lspconfig and roslyn.nvim for C#
- **Debugging**: Full DAP (Debug Adapter Protocol) support for C++, C, and C#/.NET
- **Autocompletion**: nvim-cmp with LSP and snippet support
- **Fuzzy Finding**: Telescope for file and text search
- **AI Assistance**: GitHub Copilot integration with chat interface
- **Git Integration**: vim-fugitive for Git operations
- **Syntax Highlighting**: Tree-sitter for accurate syntax highlighting
- **Status Line**: Lualine for a beautiful and informative status line
- **Themes**: Multiple color schemes (Tokyo Night, Catppuccin, Everforest, Flexoki)
- **Time Tracking**: WakaTime integration

## 📋 Prerequisites

### Common Requirements (Both Linux & Windows)

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for some LSP servers and Copilot)

### Windows-Specific Requirements

- **For C++ Debugging**:
  - [MSYS2](https://www.msys2.org/) with GDB installed at `C:\msys64\ucrt64\bin\gdb.exe`
  - Or use CodeLLDB (installed via Mason)
  
- **For C#/.NET Debugging**:
  - [netcoredbg](https://github.com/Samsung/netcoredbg) installed at `C:\netcoredbg\netcoredbg.exe`
  - .NET SDK

### Linux-Specific Requirements

- **For C++ Debugging**:
  - GDB (`sudo apt install gdb` or equivalent)
  - Or CodeLLDB (installed via Mason)
  
- **For C#/.NET Debugging**:
  - netcoredbg (install from GitHub releases)
  - .NET SDK

## 🚀 Installation

### Linux

```bash
# Backup existing configuration (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim
```

### Windows

```powershell
# Backup existing configuration (if any)
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# Clone this repository
git clone <your-repo-url> $env:LOCALAPPDATA\nvim

# Launch Neovim (plugins will auto-install)
nvim
```

## ⚙️ Configuration

### Editor Settings

- **Indentation**: 4 spaces
- **Line numbers**: Relative with current line number
- **Cursor line**: Highlighted
- **No backup/swap files**: Disabled for cleaner workspace
- **Transparent background**: Enabled for terminal integration
- **True color support**: Enabled

### Color Scheme

Currently using **Tokyo Night Storm**. To change the theme, edit `init.lua`:

```lua
vim.cmd.colorscheme("tokyonight-storm")  -- Change to your preferred theme
```

Available themes:
- `tokyonight-storm` / `tokyonight-night` / `tokyonight-day`
- `catppuccin` / `catppuccin-mocha` / `catppuccin-latte`
- `everforest`
- `flexoki-dark` / `flexoki-light`

## ⌨️ Key Mappings

### General

| Key | Action |
|-----|--------|
| `<leader>e` | Open file explorer (netrw) |
| `<Esc>` (in terminal) | Exit terminal mode |
| `<F7>` | Next tab |
| `<F8>` | Previous tab |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | List buffers |
| `<leader>fh` | Help tags |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<F5>` | Start/Continue debugging |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Set conditional breakpoint |
| `<leader>dr` | Open DAP REPL |
| `<leader>dt` | Terminate debugger and close UI |
| `<M-e>` (Alt+e) | Evaluate expression (normal/visual mode) |

### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>q` | Open floating diagnostic window |

### Copilot

| Key | Action |
|-----|--------|
| `<leader>cc` | Toggle Copilot Chat |

## 🐛 Debugging Setup

### C++ / C Debugging

Two debugger options available:

1. **cpptools (Microsoft C++ debugger)**
   - Uses GDB as backend
   - Select "Launch C++ (cpptools)" in DAP UI

2. **CodeLLDB**
   - Modern LLDB-based debugger
   - Select "Launch C++ (codelldb)" in DAP UI

The configuration automatically detects `hello.exe` (Windows) or `hello` (Linux) in the current file's directory.

### C# / .NET Debugging

- Uses netcoredbg
- Automatically finds DLLs in `bin/Debug/net8.0/`
- Configured for ASP.NET Core debugging with Development environment
- Ports: HTTPS (5001), HTTP (5000)

## 📦 Installed Plugins

Key plugins include:

- **lazy.nvim** - Plugin manager
- **nvim-treesitter** - Syntax highlighting
- **nvim-lspconfig** - LSP configuration
- **roslyn.nvim** - C# LSP (Roslyn)
- **nvim-cmp** - Autocompletion
- **telescope.nvim** - Fuzzy finder
- **nvim-dap** - Debugger
- **nvim-dap-ui** - Debugger UI
- **lualine.nvim** - Status line
- **copilot.vim** - GitHub Copilot
- **CopilotChat.nvim** - Copilot chat interface
- **vim-fugitive** - Git integration
- **snacks.nvim** - UI components
- **hardtime.nvim** - Vim motion training

See `lazy-lock.json` for the complete list with pinned versions.

## 🔧 Customization

The configuration is organized as follows:

```
nvim/
├── init.lua              # Main configuration file
├── lazy-lock.json        # Plugin version lock file
├── lua/
│   ├── config/          # Configuration modules
│   └── plugins/         # Plugin specifications
└── README.md            # This file
```

To customize:

1. **Add new plugins**: Create files in `lua/plugins/`
2. **Modify keybindings**: Edit `init.lua`
3. **Change LSP settings**: Edit LSP configuration in plugin files
4. **Adjust DAP configurations**: Modify the DAP section in `init.lua`

## 🔍 Cross-Platform Compatibility

The configuration automatically detects the operating system and adjusts paths accordingly:

```lua
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local sep = is_windows and "\\" or "/"
```

This ensures that:
- File paths use correct separators
- Debugger paths point to the right executables
- Mason packages are found in the correct locations

## 🤝 Contributing

Feel free to fork this configuration and customize it for your needs!

## 📝 License

This configuration is provided as-is for personal use.

## 💡 Tips

- First launch will take a few minutes as plugins install
- Use `:Lazy` to manage plugins
- Use `:Mason` to install LSP servers and tools
- Use `:checkhealth` to diagnose issues
- The configuration disables shada file to avoid cross-platform conflicts

---

**Happy coding! 🚀**
