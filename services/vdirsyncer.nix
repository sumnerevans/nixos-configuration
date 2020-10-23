{ config, pkgs, ... }: let
  icsSubscriptions = [
    { uri = "https://lug.mines.edu/schedule/ical.ics"; importTo = "LUG"; }
    { uri = "https://acm.mines.edu/schedule/ical.ics"; importTo = "ACM"; }
  ];
in
{
  systemd.user.services.vdirsyncer = {
    description = "Synchronize Calendar and Contacts";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
      ExecStartPost = "${pkgs.vdirsyncer}/bin/vdirsyncer metasync";
    };
    path = [ pkgs.pass ];
    startAt = "*:0/5";
  };

  systemd.user.services."ics-subscription-import" = let
    icsImportCurl = { uri, importTo }:
      "${pkgs.curl}/bin/curl '${uri}' | ${pkgs.khal}/bin/khal import --batch -a ${importTo}";
    icsSubscriptionImport = pkgs.writeShellScript "ics-subscription-import" ''
      set -xe

      ${concatMapStringSep "\n" icsImportCurl icsSubscriptions}
    '';
  in
    {
      description = "Download the icsSubscriptions and import using khal.";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = icsSubscriptionImport;
      };
      path = [ pkgs.pass ];
      startAt = "*:0/30";
    };
}
