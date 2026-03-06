{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.trouble-nvim;
      config = ''
        require('trouble').setup({
          height = 5,
          modes = {
            projectdiag = {
              mode = "diagnostics", -- inherit from diagnostics mode
              auto_open = true,
              auto_close = true,
              auto_preview = false,
              filter = {
                any = {
                  buf = 0, -- current buffer
                  {
                    severity = vim.diagnostic.severity.ERROR, -- errors only
                    -- limit to files in the current project
                    function(item)
                      return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                    end,
                  },
                },
              },
            },
          },
        })
      '';
    }
  ];
}
