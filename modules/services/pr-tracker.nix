{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.pr-tracker;
  serverName = "pr-tracker.${config.networking.domain}";
  pr-tracker = pkgs.callPackage ../../pkgs/pr-tracker.nix { };
  nixpkgsDir = "${cfg.homeDir}/nixpkgs";
in
{
  options = {
    services.pr-tracker = {
      enable = mkEnableOption "pr-tracker, a nixpkgs pull request channel tracker.";
      githubApiTokenFile = mkOption {
        type = types.path;
        description = "A file containing the GitHub API Token to use.";
      };
      homeDir = mkOption {
        type = types.path;
        default = "/var/lib/pr-tracker";
        description = "The home directory of the PR tracker.";
      };
      address = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "The address to listen on.";
      };
      sourceUrl = mkOption {
        type = types.str;
        default = "https://git.qyliss.net/pr-tracker";
        description = "The URL of the source code.";
      };
      port = mkOption {
        type = types.int;
        default = 5555;
        description = "The port to listen on.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create a user for pr-tracker.
    users.users.prtracker = {
      group = "prtracker";
      isSystemUser = true;
      home = cfg.homeDir;
      createHome = true;
    };
    users.groups.prtracker = { };

    # Serve via nginx reverse-proxy
    services.nginx.virtualHosts.${serverName} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://unix:/run/pr-tracker.sock:/";
        extraConfig = ''
          proxy_http_version 1.1;
        '';
      };
    };

    systemd.services.pr-tracker-clone = {
      description = "Clone nixpkgs.";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "clone-nixpkgs" ''
          if [[ ! -d ${nixpkgsDir} ]]; then
            ${pkgs.git}/bin/git clone \
              https://github.com/NixOS/nixpkgs.git \
              ${nixpkgsDir}
          fi
        '';
      };
    };

    systemd.sockets.pr-tracker = {
      description = "Socket for the PR tracker";
      wantedBy = [ "sockets.target" ];
      after = [ "pr-tracker-clone.service" ];
      before = [ "nginx.service" ];
      listenStreams = [ "/run/pr-tracker.sock" ];
    };

    systemd.services.pr-tracker = {
      description = "Nixpkgs pull request channel tracker.";
      after = [ "network.target" ];
      requires = [ "pr-tracker.socket" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.git ];
      serviceConfig = {
        Restart = "always";
        StandardInput = "file:${cfg.githubApiTokenFile}";
        ExecStart = ''
          ${pr-tracker}/bin/pr-tracker \
            --path ${nixpkgsDir} \
            --remote origin \
            --user-agent "pr-tracker (sumner)" \
            --source-url ${cfg.sourceUrl}
        '';
      };
    };
  };
}
