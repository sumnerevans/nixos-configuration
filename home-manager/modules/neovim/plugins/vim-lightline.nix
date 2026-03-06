{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = lightline-vim;
      config = ''
        let g:lightline = {
          \   'active': {
          \     'left': [
          \         [ 'mode', 'paste' ],
          \         [ 'readonly', 'filename', 'modified' ],
          \     ]
          \   },
          \   'component_expand': {
          \     'buffers': 'lightline#bufferline#buffers'
          \   },
          \   'separator': {'left': '', 'right': ''},
          \ }

        let g:lightline.colorscheme = 'one'
      '';
    }
    {
      plugin = lightline-bufferline;
      config = ''
        let g:lightline#bufferline#clickable = 1
        let g:lightline.component_raw = {'buffers': 1}
      '';
    }
  ];
}
