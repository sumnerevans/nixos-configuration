{
  boot.tmp.useTmpfs = true;
  boot.loader.grub.devices = [ "/dev/sda" ];

  boot.loader.grub.configurationLimit = 25;
  boot.loader.systemd-boot.configurationLimit = 25;

  boot.loader.efi.canTouchEfiVariables = true;
}
