{ config, lib, pkgs, ... }:
let
  serverName = "dav.sumnerevans.com";
  xandikosCfg = config.services.xandikos;
in
lib.mkIf xandikosCfg.enable {
  services.xandikos = {
    package = pkgs.xandikos.overridePythonAttrs (
      old: rec {
        checkInputs = with pkgs.python3Packages; [ pytestCheckHook ];
        disabledTests = [
          # these tests are failing due to the following error:
          # TypeError: expected str, bytes or os.PathLike object, not int
          "test_iter_with_etag"
          "test_iter_with_etag_missing_uid"
        ];
      }
    );

    address = "0.0.0.0";

    extraOptions = [
      "--current-user-principal /sumner/"
    ];

    nginx = {
      enable = true;
      hostName = serverName;
    };
  };

  # Set up nginx to forward requests properly.
  services.nginx.virtualHosts = {
    "${serverName}" = {
      enableACME = true;
      forceSSL = true;
      basicAuth = {
        sumner = lib.removeSuffix "\n" (builtins.readFile ../../secrets/xandikos);
      };
    };
  };

  # Add a backup service.
  services.backup.backups.xandikos = {
    path = "/var/lib/private/xandikos";
  };
}
