{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.conform-nvim;
      config = ''
        require("conform").setup({
          formatters_by_ft = {
            cs = { "csharpier" },
            go = { "goimports" },
            markdown = { "deno_fmt" },
            nix = { "nixfmt" },
            typescript = { "prettier" },
          },
          formatters = {
            csharpier = { command = "${pkgs.csharpier}/bin/csharpier" },
            deno_fmt = { command = "${pkgs.deno}/bin/deno" },
            goimports = { command = "${pkgs.gotools}/bin/goimports" },
            nixfmt = { command = "${pkgs.nixfmt}/bin/nixfmt" },
            prettier = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier",
              prepend_args = { "--trailing-comma", "es5" },
            },
          },
        })
        vim.keymap.set('n', '<C-f>', function()
          require("conform").format {
            lsp_fallback = "always",
            timeout_ms = 5000,
          }
        end, opts)
      '';
    }
  ];
}
