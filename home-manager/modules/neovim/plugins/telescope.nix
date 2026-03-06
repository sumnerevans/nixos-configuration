{ pkgs, ... }:
with pkgs;
{
  programs.neovim = {
    extraPackages = [
      delta
      fd
      fzy
      ripgrep
    ];
    plugins = [
      {
        type = "lua";
        plugin = vimPlugins.telescope-fzy-native-nvim;
      }
      {
        type = "lua";
        plugin = vimPlugins.telescope-nvim;
        config = ''
          require('telescope').setup {
            defaults = {
              layout_strategy = 'vertical',
              layout_config = {
                width = 0.80,
                height = 0.85,
              },
              mappings = {
                i = {
                  ["<esc>"] = require("telescope.actions").close,
                },
              },
              vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                '--hidden',
                '--no-ignore',
                '--glob',
                '!.git',
                '--glob',
                '!node_modules',
                '--glob',
                '!dist',
                '--glob',
                '!.direnv',
                '--glob',
                '!.venv',
              },
            },
            pickers = {
              find_files = {
                layout_strategy = 'horizontal',
                layout_config = {
                  preview_width = 0.4,
                },
                find_command = {
                  "rg",
                  "--files",
                  "--color=never",
                  "--no-heading",
                  "--with-filename",
                  "--line-number",
                  "--column",
                  "--smart-case",
                  '--hidden',
                  '--no-ignore',
                  '--glob',
                  '!.git',
                  '--glob',
                  '!node_modules',
                  '--glob',
                  '!dist',
                  '--glob',
                  '!.direnv',
                  '--glob',
                  '!.venv',
                },
              },
              live_grep = {
                layout_config = { preview_height = 0.7 },
              },
              grep_string = {
                layout_config = { preview_height = 0.7 },
              },
              lsp_definitions = {
                layout_config = { preview_height = 0.75 },
              },
              lsp_implementations = {
                layout_config = { preview_height = 0.75 },
              },
              lsp_references = {
                layout_config = { preview_height = 0.75 },
              },
              lsp_dynamic_workspace_symbols = {
                layout_config = { preview_height = 0.75 },
              },
            },
          }

          require('telescope').load_extension('fzy_native')

          local telescope_builtin = require('telescope.builtin')
          vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, {})
          vim.keymap.set('n', '<C-S>', function()
            telescope_builtin.grep_string({
              search = "",
              only_sort_text = true,
            })
          end, {})
          vim.keymap.set('v', '<C-S>', telescope_builtin.grep_string, {})
        '';
      }
      {
        type = "lua";
        plugin = vimPlugins.telescope-undo-nvim;
        config = ''
          require('telescope').setup {
            extensions = {
              undo = {
                side_by_side = true,
              },
            },
          }
          require("telescope").load_extension("undo")

          vim.keymap.set('n', '<S-U>', require("telescope").extensions.undo.undo, {})
        '';
      }
    ];
  };
}
