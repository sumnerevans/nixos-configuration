{ pkgs, ... }: {
  users.users.sumner = {
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/sumner";
    hashedPassword =
      "$6$p0WfA2vae4b5QahY$/qCwuUV.tVZEajIq7xcFUqcVD6iXAOK0kVPxki27flq4NXNn1XTTbH4s0RQedyKArAg1D2.Y0V0xQF.B/TME90";
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "wheel" # Enable 'sudo' for the user.
    ];

    # Allow all of my computers to SSH in.
    openssh.authorizedKeys.keys = import ./sumner-ssh-pubkeys.nix;
  };
}
