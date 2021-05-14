{ pkgs, ... }: {
  # Environment variables
  environment.homeBinInPath = true;

  # Packages to install
  environment.systemPackages = with pkgs; [
    # TODO put a lot of these in to the window manager serivce
    lm_sensors
    wireguard
  ];

  # Automatically start an SSH agent.
  programs.ssh.startAgent = true;

  # Enable ZSH for the command-not-found functionality
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
