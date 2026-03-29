{ config, lib, ... }:
{
  config = lib.mkIf (config.hostCategory == "server") {
    boot = {
      kernelParams = [ "console=ttyS0,19200n8" ];
      loader = {
        timeout = 10;
        grub = {
          devices = [ "/dev/sda" ];
          configurationLimit = 25;
          extraConfig = ''
            serial --speed=19200 --unit=0 --word=8 --party=no --stop=1;
            terminal_input serial;
            terminal_output serial;
          '';
        };
      };
    };

    networking.usePredictableInterfaceNames = false;

    services.journald.extraConfig = ''
      SystemMaxUse=2G
    '';

    services.nginx.virtualHosts = {
      "${config.networking.hostName}.${config.networking.domain}" = {
        forceSSL = true;
        enableACME = true;

        # Enable a status page and expose it.
        locations."/status".extraConfig = ''
          stub_status on;
          access_log off;
        '';
      };
    };

    nix.gc = {
      automatic = true;
      randomizedDelaySec = "45min";
      options = "--delete-older-than 30d";
    };
  };
}
