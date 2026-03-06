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
        plugin = Ionide-vim;
        config = ''
          let g:fsharp#lsp_auto_setup = 0
          let g:fsharp#exclude_project_directories = ['paket-files']
        '';
      }
      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = ''
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          vim.lsp.config("bashls", {
            cmd = { "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start" },
            capabilities = capabilities,
          })
          vim.lsp.config("clangd", {
            cmd = { "${pkgs.clang-tools}/bin/clangd" },
            capabilities = capabilities,
          })
          vim.lsp.config("csharp_ls", {
            cmd = { "${pkgs.csharp-ls}/bin/csharp-ls" },
            capabilities = capabilities,
          })
          vim.lsp.config("cssls", {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
            capabilities = capabilities,
          })
          vim.lsp.config("eslint", {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio" },
            capabilities = capabilities,
          })
          vim.lsp.config("gopls", {
            cmd = { "${pkgs.gopls}/bin/gopls" },
            capabilities = capabilities,
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
          })
          vim.lsp.config("harper_ls", {
            cmd = { "${pkgs.harper}/bin/harper-ls", "--stdio" },
            capabilities = capabilities,
            settings = {
              ["harper-ls"] = {
                userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
              }
            },
          })
          vim.lsp.config("html", {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
            capabilities = capabilities,
          })
          vim.lsp.config("jsonls", {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio" },
            capabilities = capabilities,
          })
          vim.lsp.config("kotlin_language_server", {
            cmd = { "${pkgs.kotlin-language-server}/bin/kotlin-language-server" },
            capabilities = capabilities,
          })
          vim.lsp.config("nil_ls", {
            cmd = { "${pkgs.nil}/bin/nil" },
            capabilities = capabilities,
            settings = {
              ["nil"] = {
                formatting = {
                  command = { "${pkgs.nixfmt}/bin/nixfmt" },
                },
              },
            },
          })
          vim.lsp.config("ocamllsp", {
            cmd = { "${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp" },
            capabilities = capabilities,
          })
          vim.lsp.config("pylsp", {
            cmd = { "${pylspPython}/bin/pylsp" },
            capabilities = capabilities,
            settings = {
              pylsp = {
                plugins = {
                  pyls_black = { enabled = true },
                  isort = { enabled = true, profile = "black" },
                },
              },
            },
          })
          vim.lsp.config("templ", {
            cmd = { "templ", "lsp" },
            capabilities = capabilities,
          })
          vim.lsp.config("texlab", {
            cmd = { "${pkgs.texlab}/bin/texlab" },
            capabilities = capabilities,
          })
          vim.lsp.config("tinymist", {
            cmd = { "${pkgs.tinymist}/bin/tinymist" },
            capabilities = capabilities,
            settings = {
              formatterMode = "typstyle",
              exportPdf = "onType",
            },
          })
          vim.lsp.config("ts_ls", {
            cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
            capabilities = capabilities,
          })
          vim.lsp.config("vale_ls", {
            cmd = { "${pkgs.vale-ls}/bin/vale-ls" },
            capabilities = capabilities,
          })
          vim.lsp.config("yamlls", {
            cmd = { "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server", "--stdio" },
            capabilities = capabilities,
            settings = {
              yaml = {
                schemas = {
                  ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                },
              },
            },
          })

          vim.lsp.enable("bashls")
          vim.lsp.enable("clangd")
          vim.lsp.enable('csharp_ls')
          vim.lsp.enable("cssls")
          vim.lsp.enable("eslint")
          vim.lsp.enable("gopls")
          vim.lsp.enable("harper_ls")
          vim.lsp.enable("html")
          vim.lsp.enable("jsonls")
          vim.lsp.enable("kotlin_language_server")
          vim.lsp.enable("nil_ls")
          vim.lsp.enable("ocamllsp")
          vim.lsp.enable("pylsp")
          vim.lsp.enable("templ")
          vim.lsp.enable("texlab")
          vim.lsp.enable("tinymist")
          vim.lsp.enable("ts_ls")
          vim.lsp.enable("vale_ls")
          vim.lsp.enable("yamlls")

          -- F#
          require('ionide').setup {
            autostart = true,
            capabilities = capabilities,
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

          local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
          local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

          -- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = 'rounded',
            max_width = max_width,
            max_height = max_height,
          })

          vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = 'rounded',
            max_width = max_width,
            max_height = max_height,
          })
        '';
      }
    ];
  };
}
