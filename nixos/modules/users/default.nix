{
  pkgs,
  lib,
  config,
  ...
}:
{
  users = {
    mutableUsers = false;

    users = {
      root = {
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys =
          (builtins.attrValues (import ./sumner-ssh-pubkeys.nix))
          ++ (builtins.attrValues (import ./server-pubkeys.nix));
      };

      sumner = lib.mkIf (config.hostCategory == "laptop") {
        shell = pkgs.zsh;
        isNormalUser = true;
        home = "/home/sumner";
        hashedPassword = "$6$p0WfA2vae4b5QahY$/qCwuUV.tVZEajIq7xcFUqcVD6iXAOK0kVPxki27flq4NXNn1XTTbH4s0RQedyKArAg1D2.Y0V0xQF.B/TME90";
        extraGroups = [
          "audio"
          "docker"
          "networkmanager"
          "wheel" # Enable 'sudo' for the user.
          "adbusers"
        ];

        openssh.authorizedKeys.keys = (builtins.attrValues (import ./sumner-ssh-pubkeys.nix));
      };
    };
  };
}
