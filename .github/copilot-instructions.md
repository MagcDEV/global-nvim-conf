# Copilot Instructions

## Commands

This repository does not define formal build, lint, or test scripts.

Use these repository-native validation commands instead:

- `nvim` — launch Neovim and let `lazy.nvim` bootstrap/install plugins on first run.
- `nvim --headless "+checkhealth" +qa` — run Neovim health checks from the terminal.
- `nvim "+Lazy"` — open the plugin manager UI to inspect plugin state and updates.
- `nvim "+Mason"` — open Mason to inspect or install language servers and debugger tools.

There is no single-test command because the repo does not include an automated test suite.

## High-level architecture

- `init.lua` is the main entrypoint. It sets editor options, loads `lua/config/lazy.lua`, selects the active colorscheme, defines global keymaps, and contains the full DAP setup for C/C++ and C#.
- `lua/config/lazy.lua` bootstraps `lazy.nvim`, sets `mapleader` / `maplocalleader`, and imports every plugin spec from `lua/plugins`.
- `lua/plugins/*.lua` contains the lazy.nvim plugin specs. Most files own one plugin or a small related group of plugins.
- Plugin declaration and plugin behavior are intentionally split in some places:
  - `lua/plugins/dap.lua` declares DAP-related plugins, but the actual debugger adapters, configurations, listeners, and debug keymaps live in `init.lua`.
  - `lua/plugins/lsp-config.lua` defines LSP startup/config for `lua_ls` and `clangd`.
  - `lua/plugins/mason.lua` manages installation of LSP and DAP tooling.
  - `lua/plugins/roslyn.lua` handles C# via `roslyn.nvim` instead of the generic LSP config file.
- AI integrations are configured as plugins (`copilot.lua`, `copilotChat.lua`, `opencode.lua`, `sidekick.lua`), while user-facing keymaps such as `<leader>cc` are kept in `init.lua`.

## Key conventions

- Add or change plugins through `lua/plugins/*.lua`, not by editing `lua/config/lazy.lua`. That file should stay focused on bootstrapping `lazy.nvim`.
- Follow the existing lazy.nvim spec style: each plugin file returns a Lua table, using fields like `dependencies`, `config`, `opts`, `keys`, `build`, and `lazy = false`.
- Formatting and linting integrations live in their own plugin spec files under `lua/plugins/`, not in `init.lua`.
- Keep simple plugin-specific setup inside the plugin spec file. Keep cross-plugin/editor-wide behavior in `init.lua`. In this repo that includes:
  - global keymaps
  - colorscheme and highlight overrides
  - DAP adapter/configuration logic
- Preserve the cross-platform pattern already used in `init.lua`:
  - detect Windows with `vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1`
  - derive the path separator from that check
  - prefer `vim.fn.stdpath("data")` when locating Mason-managed binaries
- `lazy-lock.json` is the pinned plugin state for the repo. Treat it as generated lock data that changes when plugin versions are updated.
- Theme plugins are split into separate files, but the active theme is selected in `init.lua` with `vim.cmd.colorscheme(...)`.
- LSP startup is not fully automatic through Mason alone. `lua/plugins/lsp-config.lua` uses `vim.lsp.config` plus `FileType` autocmds to start configured servers, while C# is handled separately by `roslyn.nvim`.
- The repo is tuned for Windows and Linux. Be careful with hardcoded tool paths when changing LSP or debugger setup, and keep cross-platform behavior aligned with the existing OS-detection pattern.
