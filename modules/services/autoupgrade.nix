{
  # Keep the system up-to-date automatically.
  system.autoUpgrade = {
    enable = true;
    dates = "monthly";
    channel = https://nixos.org/channels/nixos-unstable;
  };
}
