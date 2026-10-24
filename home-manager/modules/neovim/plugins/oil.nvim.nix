{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.oil-nvim;
      config = ''
        oil = require("oil")
        oil.setup {
          delete_to_trash = false,
          view_options = {
            show_hidden = true,
          },
        }

        vim.keymap.set('n', '<S-T>', function()
          local root = vim.fs.root(0, ".git")
          if root then
            oil.toggle_float(root)
          else
            oil.toggle_float()
          end
        end)
      '';
    }
  ];
}
