{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  feh = "${pkgs.feh}/bin/feh";
  icalviewScript = pkgs.writeScript "icalview" (builtins.readFile ./icalview.py);
  hasGui = config.wayland.enable || config.xorg.enable;

  programSection =
    executable: items:
    (listToAttrs (
      map (mimetype: {
        name = mimetype;
        value = executable;
      }) items
    ));

  mailcapConfig = {
    # HTML
    "text/html" = [
      "${pkgs.elinks}/bin/elinks -dump %s"
      "copiousoutput"
    ];

    # Patch files
    "text/x-patch" = [
      ''${pkgs.mdf}/bin/mdf --root-uri "http://localhost:${toString config.mdf.port}"''
      "copiousoutput"
    ];
  }

  // (optionalAttrs hasGui {
    # PDF documents
    "application/pdf" = [ "${pkgs.zathura}/bin/zathura %s" ];
  })

  # Images
  // (programSection
    [ "${feh} %s" ]
    [
      "image/jpg"
      "image/jpeg"
      "image/pjpeg"
      "image/png"
      "image/gif"
    ]
  )

  # iCal
  // (programSection
    [ icalviewScript "copiousoutput" ]
    [
      "text/calendar"
      "application/calendar"
      "application/ics"
    ]
  );
in
{
  xdg.configFile."neomutt/mailcap".text = concatStringsSep "\n" (
    mapAttrsToList (name: value: "${name}; ${concatStringsSep "; " value};") mailcapConfig
  );
}
