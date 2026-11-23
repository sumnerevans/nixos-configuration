{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityFile = "~/.ssh/id_rsa";
      # Add keys to the agent the first time they are used.
      AddKeysToAgent = "yes";
    };
  };

  services.ssh-agent.enable = true;
}
