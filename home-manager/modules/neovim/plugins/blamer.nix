# Enable git blame on the line.
{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.blamer-nvim;
      config = ''
        let g:blamer_enabled = 1
        let g:blamer_date_format = '%Y-%m-%d'
        let g:blamer_template = '<committer>, <committer-time> • <commit-short> • <summary>'
      '';
    }
  ];
}
