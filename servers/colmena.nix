{ nixpkgs, ... }:
let system = "x86_64-linux";
in {
  meta = {
    description = "Sumner's Personal Infrastructure";

    nixpkgs = import nixpkgs {
      inherit system;
      config.permittedInsecurePackages = [ "olm-3.2.16" ];
    };
  };

  defaults = { config, ... }: {
    imports = [ ./modules ];

    deployment.replaceUnknownProfiles = true;

    system.stateVersion = "23.05";

    swapDevices = [{
      device = "/var/swapfile";
      size = 4096;
    }];

    services.logrotate.enable = true;
  };

  jedha = {
    deployment = {
      targetHost = "192.168.0.168";
      tags = [ "belleview" ];
    };

    imports = [ ./hosts/jedha ];
  };

}
