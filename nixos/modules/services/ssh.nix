{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      StreamLocalBindUnlink = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
