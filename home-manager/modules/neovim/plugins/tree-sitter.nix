# Tree Sitter
{ pkgs, ... }:
with pkgs;
let
  luaPlugin = pkg: {
    type = "lua";
    plugin = pkg;
  };
in
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (luaPlugin nvim-treesitter-parsers.bash)
      (luaPlugin nvim-treesitter-parsers.c)
      (luaPlugin nvim-treesitter-parsers.comment)
      (luaPlugin nvim-treesitter-parsers.cpp)
      (luaPlugin nvim-treesitter-parsers.diff)
      (luaPlugin nvim-treesitter-parsers.git_config)
      (luaPlugin nvim-treesitter-parsers.git_rebase)
      (luaPlugin nvim-treesitter-parsers.gitattributes)
      (luaPlugin nvim-treesitter-parsers.gitignore)
      (luaPlugin nvim-treesitter-parsers.go)
      (luaPlugin nvim-treesitter-parsers.gomod)
      (luaPlugin nvim-treesitter-parsers.gosum)
      (luaPlugin nvim-treesitter-parsers.gowork)
      (luaPlugin nvim-treesitter-parsers.html)
      (luaPlugin nvim-treesitter-parsers.kotlin)
      (luaPlugin nvim-treesitter-parsers.javascript)
      (luaPlugin nvim-treesitter-parsers.javascript)
      (luaPlugin nvim-treesitter-parsers.json)
      (luaPlugin nvim-treesitter-parsers.json5)
      (luaPlugin nvim-treesitter-parsers.lua)
      (luaPlugin nvim-treesitter-parsers.markdown)
      (luaPlugin nvim-treesitter-parsers.nix)
      (luaPlugin nvim-treesitter-parsers.ocaml)
      (luaPlugin nvim-treesitter-parsers.proto)
      (luaPlugin nvim-treesitter-parsers.python)
      (luaPlugin nvim-treesitter-parsers.sql)
      (luaPlugin nvim-treesitter-parsers.templ)
      (luaPlugin nvim-treesitter-parsers.terraform)
      (luaPlugin nvim-treesitter-parsers.tsx)
      (luaPlugin nvim-treesitter-parsers.vim)
      (luaPlugin nvim-treesitter-parsers.vimdoc)
      (luaPlugin nvim-treesitter-parsers.xml)
      (luaPlugin nvim-treesitter-parsers.yaml)

      (luaPlugin vim-matchup)
      {
        type = "lua";
        plugin = (
          nvim-treesitter-context.overrideAttrs (old: rec {
            pname = "nvim-treesitter-context";
            version = "2024-04-03";

            src = fetchFromGitHub {
              owner = "nvim-treesitter";
              repo = pname;
              rev = "93b29a32d5f4be10e39226c6b796f28d68a8b483";
              sha256 = "sha256-D4i4ChXK9yWCd/uBIkZaWq5hoYcBRfznHPbIRRaOPYo=";
            };
          })
        );
        config = ''
          require'treesitter-context'.setup{mode = 'topline'}
        '';
      }
      {
        type = "lua";
        plugin = nvim-treesitter;
        config = ''
          require('nvim-treesitter').setup({
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            matchup = { enable = true },
          })

          vim.filetype.add({
            extension = {
              templ = 'templ',
            },
          })
        '';
      }
    ];
  };
}
