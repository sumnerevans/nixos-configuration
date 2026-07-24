{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.enableVirtualisation = lib.mkEnableOption "libvirtd and virt-manager for running VMs.";

  config = lib.mkIf config.enableVirtualisation {
    virtualisation.libvirtd.enable = true;
    users.users.sumner.extraGroups = [ "libvirtd" ];
    environment.systemPackages = [ pkgs.virt-manager ];
  };
}
