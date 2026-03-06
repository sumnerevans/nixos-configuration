{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  configs = {
    KohakuInternal = {
      criteria = "Unknown 0x4142";
      mode = "3840x2160@60Hz";
      scale = 1.75;
      position = "0,0";
    };
    ThinkVision = {
      criteria = "Lenovo Group Limited M14 V906P5HA";
      mode = "1920x1080@60Hz";
    };
    DellP2421D = {
      criteria = "Dell Inc. DELL P2421D D643X53";
      mode = "2560x1440@60Hz";
      position = "2560,0";
    };
    DellS2417DG = {
      criteria = "Dell Inc. Dell S2417DG #ASNmc/dFujvd";
      mode = "2560x1440@143.998Hz";
    };
    ScarifInternal = {
      criteria = "InfoVision Optoelectronics (Kunshan) Co.,Ltd China 0x8C44 Unknown";
      mode = "1920x1200@60Hz";
      position = "0,0";
    };
    AutomatticInternal = {
      criteria = "Lenovo Group Limited 0x4149 Unknown";
      mode = "2880x1800@60Hz";
      scale = 1.6;
      position = "0,0";
    };
  };
in
{
  config = mkIf config.wayland.windowManager.sway.enable {
    home.packages = [ pkgs.kanshi ];
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "Kohaku_Undocked";
          profile.outputs = [ configs.KohakuInternal ];
        }

        {
          profile.name = "Kohaku_ThinkVision";
          profile.outputs = [
            configs.KohakuInternal
            (configs.ThinkVision // { position = "2194,0"; })
          ];
        }

        {
          profile.name = "DoubleDell";
          profile.outputs = [
            configs.DellP2421D
            configs.DellS2417DG
          ];
        }

        {
          profile.name = "ScarifUndocked";
          profile.outputs = [ configs.ScarifInternal ];
        }
        {
          profile.name = "ScarifDockedOne";
          profile.outputs = [
            (configs.DellS2417DG // { position = "1920,0"; })
            configs.ScarifInternal
          ];
        }

        {
          profile.name = "AutomatticUndocked";
          profile.outputs = [ configs.AutomatticInternal ];
        }
        {
          profile.name = "AutomatticDockedOne";
          profile.outputs = [
            (configs.DellS2417DG // { position = "2880,0"; })
            configs.AutomatticInternal
          ];
        }
        {
          profile.name = "Automattic_ThinkVision";
          profile.outputs = [
            configs.AutomatticInternal
            (configs.ThinkVision // { position = "1920,0"; })
          ];
        }
      ];
    };
  };
}
