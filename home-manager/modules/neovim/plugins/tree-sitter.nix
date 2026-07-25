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
      (luaPlugin vim-matchup)
      {
        type = "lua";
        plugin = nvim-treesitter-context;
        config = ''
          require'treesitter-context'.setup{mode = 'topline'}
        '';
      }

      (luaPlugin pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
      {
        type = "lua";
        plugin = nvim-treesitter;
        config = ''
          require('nvim-treesitter').setup({})

          vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
              local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
              local ok, added = pcall(vim.treesitter.language.add, lang)
              if lang and ok and added then
                vim.treesitter.start(args.buf, lang)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
              end
            end,
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
