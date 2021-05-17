{ config, lib, ... }: with lib; let
  hostnameDomain = "${config.networking.hostName}.${config.networking.domain}";
  websites = config.nginx.websites;

  permissionsPolicyDisables = [
    "accelerometer"
    "camera"
    "geolocation"
    "gyroscope"
    "interest-cohort"
    "magnetometer"
    "microphone"
    "payment"
    "usb"
  ];

  # https://securityheaders.com/?q=sumnerevans.com&followRedirects=on
  securityHeaders = mapAttrsToList (k: v: ''add_header ${k} "${v}";'') {
    # Disable using my website in FLoC calculations.
    # https://scotthelme.co.uk/goodbye-feature-policy-and-hello-permissions-policy/
    "Permissions-Policy" = concatMapStringsSep ", " (d: "${d}=()") permissionsPolicyDisables;
    "Strict-Transport-Security" = "max-age=31536000; includeSubDomains";
    "X-Frame-Options" = "SAMEORIGIN";
    "X-Content-Type-Options" = "nosniff";
    "Referrer-Policy" = "same-origin";
    "Content-Security-Policy" = "default-src https: 'unsafe-inline' 'unsafe-eval'";
  };
in
{
  options =
    let
      websiteSubmodule = { name, ... }: {
        options = {
          hostname = mkOption {
            type = types.str;
            description = "The hostname of the website.";
          };
          extraLocations = mkOption {
            type = with types; attrsOf anything;
            default = { };
          };
          excludeTerms = mkOption {
            type = with types; listOf str;
            default = [ ];
          };
        };
      };
    in
    {
      nginx.websites = mkOption {
        type = with types; listOf (submodule websiteSubmodule);
        default = [ ];
      };
    };

  config = mkIf (websites != [ ]) {
    # Enable nginx and add the static websites.
    services.nginx = {
      enable = true;
      enableReload = true;
      clientMaxBodySize = "250m";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts =
        let
          websiteConfig = { hostname, extraLocations, ... }: {
            name = hostname;
            value = {
              forceSSL = true;
              enableACME = true;
              locations = extraLocations // {
                "/" = {
                  root = "/var/www/${hostname}";
                  extraConfig = ''
                    # Put logs for each website in a separate log file.
                    access_log /var/log/nginx/${hostname}.access.log;

                    ${concatStringsSep "\n" securityHeaders}
                  '';
                };
              };
            };
          };
        in
        (optionalAttrs (config.networking.domain != null) {
          ${hostnameDomain} = {
            forceSSL = true;
            enableACME = true;

            # Enable a status page and expose it.
            locations."/status".extraConfig = ''
              stub_status on;
              access_log off;
            '';
          };
        })
        // listToAttrs (map websiteConfig websites);
    };

    # Add metrics displays for each of the websites.
    services.metrics.websites = websites;

    # Open up the ports
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
