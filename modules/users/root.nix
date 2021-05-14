{ pkgs, ... }: {
  users.users.root = {
    shell = pkgs.zsh;

    # Allow all of my computers to SSH in.
    openssh.authorizedKeys.keys = (import ./sumner-ssh-pubkeys.nix) ++ [
      # Allow Sourcehut deploy to SSH in and upgrade the server.
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0CbfyzxbTTST4bYVZ4qhV8WQR1EWDRlzhaX4MfCGT3DyokXSfhe+RWdvo2FGFwduFMkVEKTGbMCkdt7Ip3vNYuWNB36oimEV9zB37ejD6wPZcEem/P9PR0gb0Cy/XuMkBhXaeA+vPSGU9WRBOuVuFQQRX+NoC62KTwmZac1ro9nx4bMa2OYDnDNh2ogSXVkHGutpP+iUnESTA3d2fB1j9x+wbDRmDQvrYKdlC8mNeSuzDd/1KL0eDI+Y2rmdKZ+QZW/E2Y41l7AI7IOG2i1Y+aS8JkhUjZmO9Ci3ApMHbGtL6X42oQ+TxDIQVBq/GKEbWLigsp1WlqeEzqA+GbOp Sourcehut"
    ];
  };
}
