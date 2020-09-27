{ config, pkgs, ... }: let
  offlinemsmtp = callPackage ../programs/offlinemsmtp.nix { };
in
{
  systemd.user.services.offlinemsmtp = {
    description = "offlinemsmtp daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${offlinemsmtp}/bin/offlinemsmtp --daemon";
    # path = with pkgs; [
    #   libnotify
    #   (python38.withPackages(ps: with ps; [
    #     notify
    #     pygobject3
    #   ]))
    # ];
  };
}
