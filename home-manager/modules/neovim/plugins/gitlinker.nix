{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.gitlinker-nvim;
      type = "lua";
      config = ''
        require("gitlinker").setup({
          opts = { print_url = false },
          mappings = nil,
        })

        vim.keymap.set('n', '<space>gl', function()
          require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
        end, { silent = true })
        vim.keymap.set('v', '<space>gl', function()
          require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser })
        end, { silent = true })
      '';
    }
  ];
}
