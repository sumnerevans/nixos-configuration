{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [
      {
        plugin = pkgs.vimPlugins.sqlite-lua;
        config = ''
          let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
        '';
      }
      {
        type = "lua";
        plugin = pkgs.vimPlugins.nvim-neoclip-lua;
        config = ''
          require('neoclip').setup {
            history = 10000,
            enable_persistent_history = true,
            default_register = { '"', '+', '*' },
          }

          vim.keymap.set('n', '<M-c>', require("telescope").extensions.neoclip.default, {})
        '';
      }
    ];
  };
}
