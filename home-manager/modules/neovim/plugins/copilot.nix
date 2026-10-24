{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.copilot-lua;
      config = ''
        require('copilot').setup({
          panel = { enabled = false },
          suggestion = {
            enabled = true,
            auto_trigger = true,
          },
        })

        vim.keymap.set('i', '<C-c>', require("copilot.suggestion").accept, {})
        vim.keymap.set('i', '<C-h>', require("copilot.suggestion").prev, {})
        vim.keymap.set('i', '<C-l>', require("copilot.suggestion").next, {})
      '';
    }
  ];
}
