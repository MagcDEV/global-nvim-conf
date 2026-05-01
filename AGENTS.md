# AGENTS.md

Personal Neovim configuration. Not a software project — no build, lint, test, or typecheck commands exist.

## Bootstrap / validation

- `nvim` — first launch auto-bootstraps `lazy.nvim` and installs all plugins
- `nvim --headless "+checkhealth" +qa` — run health checks
- `nvim "+Lazy"` / `nvim "+Mason"` — plugin manager / tool installer UIs

## Architecture

```
init.lua              → editor settings, colorscheme, highlights, global keymaps
lua/config/lazy.lua   → bootstraps lazy.nvim, imports lua/plugins/*
lua/plugins/*.lua     → one lazy.nvim spec per file (or small grouped specs)
```

## Where things live (non-obvious)

| Concern | Location |
|---|---|
| DAP adapters, configurations, keymaps, listeners | `lua/plugins/dap.lua` |
| LSP startup config + LSP keymaps (`K`, `gd`, `gi`, `gr`, etc.) | `lua/plugins/lsp-config.lua` |
| Mason tool install lists (LSPs, DAP, Go tools) | `lua/plugins/mason.lua` |
| Global keymaps (Telescope, diagnostics, file nav) | `init.lua` |
| Colorscheme selection + highlight overrides | `init.lua` |
| C# LSP | `lua/plugins/roslyn.lua` |

## Conventions

- **Add plugins** via new files in `lua/plugins/`. Do NOT edit `lua/config/lazy.lua` — it only bootstraps the plugin manager and imports the plugins directory.
- Each plugin file returns a lazy.nvim spec table. Use `config`, `opts`, `dependencies`, `keys`, `build` fields as appropriate.
- **lazy-lock.json** is auto-generated. Treat as immutable lock data.
- **LSP startup** uses `vim.lsp.config` (Neovim 0.11+ API): configs are stored in `vim.lsp.config[name]`, then started via `FileType` autocmd calling `vim.lsp.start()`. Roslyn handles C# independently.
- **Cross-platform pattern** (use this, not custom detection):
  ```lua
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local sep = is_windows and "\\" or "/"
  ```
  Prefer `vim.fn.stdpath("data")` over hardcoded paths for Mason-installed tools.

## Gotchas

- Hardcoded Windows tool paths exist in this config:
  - `clangd`: `C:/msys64/ucrt64/bin/clangd.exe`
  - `gdb`: `C:/msys64/ucrt64/bin/gdb.exe`
  - `netcoredbg`: `C:/netcoredbg/netcoredbg.exe`
  - clangd `fallbackFlags` include `--target=x86_64-w64-windows-gnu`
- `vim.opt.shadafile = "NONE"` disables shada to avoid cross-platform conflicts.
- No `.gitignore`, no CI, no automated tests.
