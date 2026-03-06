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
      (luaPlugin cmp-async-path)
      (luaPlugin cmp-fuzzy-buffer)
      (luaPlugin cmp-nvim-lsp)
      (luaPlugin cmp-nvim-lsp-signature-help)
      (luaPlugin lspkind-nvim)
      (luaPlugin luasnip)
      {
        type = "lua";
        plugin = cmp-spell;
        config = ''
          vim.opt.spell = true
          vim.opt.spelllang = { 'en_us' }
        '';
      }
      {
        type = "lua";
        plugin = nvim-cmp;
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")

          local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
          end

          cmp.setup({
            formatting = {
              format = require("lspkind").cmp_format({
                mode = 'symbol', -- show only symbol annotations
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                preset = "codicons", -- codicons preset
              })
            },
            preselect = cmp.PreselectMode.None,
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            sources = {
              { name = "nvim_lsp", priority = 100 },
              { name = "nvim_lsp_signature_help", priority = 90 },
              { name = "async_path", priority = 80 },
              { name = "spell", priority = 70 },
              { name = "fuzzy_buffer", priority = 60 },
              { name = "luasnip", priority = 50 },
            },
            window = {
              documentation = cmp.config.window.bordered(),
            },
            sorting = {
              priority_weight = 1.0,
              comparators = {
                cmp.config.compare.locality,
                cmp.config.compare.recently_used,
                cmp.config.compare.score,
                cmp.config.compare.offset,
                cmp.config.compare.order,
              },
            },
            mapping = {
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<CR>"] = cmp.mapping({
                i = function(fallback)
                  if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                  else
                    fallback()
                  end
                end,
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
              }),
              ['<C-y>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              }),
            },
          })
        '';
      }
    ];
  };
}
