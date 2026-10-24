{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  hostCategory = "laptop";
  ramSize = 16;
  dmsGreeterMonitorScale = 1.5;

  # The Framework kernel module currently fails to build with linuxPackages_latest.
  hardware.framework.enableKmod = false;

  networking.hostName = "scarif";

  # Allow temporary redirects directly to the reverse proxy.
  networking.firewall.allowedTCPPorts = [
    8222
    8080
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8008;
      to = 8015;
    }
  ];

  programs.steam.enable = true;

  virtualisation.docker.enable = true;
  enableVirtualisation = true;

  zramSwap.enable = true;

  services.fprintd.enable = true; # Enable the fingerprint scanner

  # A suspend race can leave fprintd holding a stale claim on the Goodix
  # reader. Restart it asynchronously after resume so it can claim the device
  # again. Check the upstream merge request for a fix before removing this:
  # https://gitlab.freedesktop.org/libfprint/fprintd/-/merge_requests/259
  environment.etc."systemd/system-sleep/fprintd-resume".source =
    pkgs.writeShellScript "fprintd-resume" ''
      if [[ $1 == post ]]; then
        # user.slice stays frozen until this hook exits, so enqueue the restart.
        ${pkgs.systemd}/bin/systemctl --no-block try-restart fprintd.service 2>/dev/null || true
      fi
    '';

  # A wedged device handle may make fprintd ignore SIGTERM during recovery.
  systemd.services.fprintd.serviceConfig.TimeoutStopSec = "3s";
}
