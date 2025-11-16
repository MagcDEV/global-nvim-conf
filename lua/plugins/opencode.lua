return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal — otherwise optional
    { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
  },

  opts = function()
    local host = "127.0.0.1"

    local function detect_port_windows()
      if vim.loop.os_uname().sysname ~= "Windows_NT" then
        return nil
      end
      local cmd = [[powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalAddress -in @('127.0.0.1','0.0.0.0','::1') -and $_.OwningProcess -and (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName -match 'opencode' } | Select-Object -First 1 -ExpandProperty LocalPort; if ($p) { $p }"]]
      local out = vim.fn.systemlist(cmd)
      local port = tonumber(out and out[1])
      if port and port > 0 then
        return port
      end
      local envp = tonumber(vim.env.OPENCODE_PORT or vim.env.OPENCODE_SERVER_PORT)
      if envp and envp > 0 then
        return envp
      end
      return nil
    end

    local port = detect_port_windows() or 53556
    return { host = host, port = port }
  end,
  keys = {
    -- Recommended keymaps
    { '<leader>oA', function() require('opencode').ask() end, desc = 'Ask opencode', },
    { '<leader>oa', function() require('opencode').ask('@cursor: ') end, desc = 'Ask opencode about this', mode = 'n', },
    { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    -- { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
    { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    -- Example: keymap for custom prompt
    { '<leader>oe', function() require('opencode').prompt("Explain @cursor and its context") end, desc = "Explain code near cursor", },
  },
}
