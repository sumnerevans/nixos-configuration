{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons
    {
      plugin = barbar-nvim;
      config = ''
        " Buffer navigation
        map <A-1> <Cmd>BufferPrevious<CR>
        map <A-2> <Cmd>BufferNext<CR>
        map <C-W> <Cmd>BufferClose<CR>

        map <A-[> <Cmd>BufferPrevious<CR>
        map <A-]> <Cmd>BufferNext<CR>
      '';
    }
  ];
}
