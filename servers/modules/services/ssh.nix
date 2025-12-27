{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      StreamLocalBindUnlink = "yes";
    };
  };
}
