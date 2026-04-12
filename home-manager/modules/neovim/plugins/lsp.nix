{ pkgs, ... }:
let
  pylspPython = pkgs.python3.withPackages (
    ps: with ps; [
      black
      isort
      mypy
      pyls-isort
      python-lsp-black
      python-lsp-server
    ]
  );
in
{
  # Make a default vale config file so the LSP doesn't explode
  xdg.configFile."vale/.vale.ini".text = "";

  programs.neovim = {
    extraPackages = with pkgs; [
      ocamlPackages.ocamlformat
      fantomas
      gopls # needed for templ
    ];
    plugins = with pkgs.vimPlugins; [
      {
        type = "viml";
        plugin = Ionide-vim;
        config = ''
          let g:fsharp#lsp_auto_setup = 0
          let g:fsharp#exclude_project_directories = ['paket-files']
        '';
      }
      {
        type = "lua";
        plugin = nvim-lspconfig;
      }
    ];

    extraLuaConfig = ''
      local lsps = {
        ["clangd"] = {
          cmd = { "${pkgs.clang-tools}/bin/clangd" },
        },
        ["csharp_ls"] = {
          cmd = { "${pkgs.csharp-ls}/bin/csharp-ls" },
        },
        ["cssls"] = {
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
          filetypes = { 'css' },
        },
        ["eslint"] = {
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio" },
        },
        ["gopls"] = {
          cmd = { "${pkgs.gopls}/bin/gopls" },
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                unusedvariable = true,
                unusedwrite = true,
                useany = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              staticcheck = true,
            },
          },
        },
        ["harper_ls"] = {
          cmd = { "${pkgs.harper}/bin/harper-ls", "--stdio" },
          filetypes = {
            'asciidoc',
            'gitcommit',
            'html',
            'markdown',
            'typst',
          },
          settings = {
            ["harper-ls"] = {
              userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
              dialect = "British",
            }
          },
        },
        ["html"] = {
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
        },
        ["jsonls"] = {
          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio" },
        },
        ["kotlin_language_server"] = {
          cmd = { "${pkgs.kotlin-language-server}/bin/kotlin-language-server" },
        },
        ["nil_ls"] = {
          cmd = { "${pkgs.nil}/bin/nil" },
          settings = {
            ["nil"] = {
              formatting = {
                command = { "${pkgs.nixfmt}/bin/nixfmt" },
              },
            },
          },
        },
        ["ocamllsp"] = {
          cmd = { "${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp" },
        },
        ["pylsp"] = {
          cmd = { "${pylspPython}/bin/pylsp" },
          settings = {
            pylsp = {
              plugins = {
                pyls_black = { enabled = true },
                isort = { enabled = true, profile = "black" },
              },
            },
          },
        },
        ["templ"] = { },
        ["tinymist"] = {
          cmd = { "${pkgs.tinymist}/bin/tinymist" },
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onType",
          },
        },
        ["ts_ls"] = {
          cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
        },
        ["vale_ls"] = {
          cmd = { "${pkgs.vale-ls}/bin/vale-ls" },
        },
      }

      for name, config in pairs(lsps) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      -- F#
      require('ionide').setup {
        autostart = true,
      }

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local telescope_builtin = require('telescope.builtin')

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, {})
          vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, {})
          vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, {})
          vim.keymap.set('n', 'S', telescope_builtin.lsp_dynamic_workspace_symbols, {})
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<F6>', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        end,
      })
    '';
  };
}
