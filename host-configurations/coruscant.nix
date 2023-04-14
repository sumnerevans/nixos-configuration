{ pkgs, ... }: {
  # Set the hostname
  networking.hostName = "coruscant";
  hardware.isPC = true;
  hardware.ramSize = 32;

  programs.sway.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.steam.enable = true;

  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp35s0.useDHCP = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 32 ];
}
