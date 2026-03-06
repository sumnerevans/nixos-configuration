{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.xorg;
  i3msg = "${pkgs.i3-gaps}/bin/i3-msg";
  fingerprints = {
    ThinkPad_Internal = "00ffffffffffff0030aeba4000000000001c0104a5221378e238d5975e598e271c505400000001010101010101010101010101010101243680a070381f403020350058c210000019502b80a070381f403020350058c2100000190000000f00d10930d10930190a0030e4e705000000fe004c503135365746432d535044420094";
    ThinkVision = "00ffffffffffff0030aedd61000000002a1e0104a51f12783aee95a3544c99260f5054bdcf84a94081008180818c9500950fa94ab300023a801871382d40582c450035ae1000001e000000fc004d31340a202020202020202020000000fd00324b1e5a14000a202020202020000000ff0056393036503548410affffffff0101020314b4499011040302011f121365030c0010007c2e90a0601a1e4030203600dc0b1100001cab22a0a050841a3030203600dc0b1100001c662156aa51001e30468f3300dc0b1100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022";

    # Dell Monitors
    Dell_S2417DG = "00ffffffffffff0010ace7a055464330241c0104a5351e7806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a02950302035000f282100001a000000ff002341534e6d632f6446756a7664000000fd001e9022de3b010a202020202020000000fc0044656c6c20533234313744470a011e020312412309070183010000654b040001015a8700a0a0a03b50302035000f282100001a5aa000a0a0a04650302035000f282100001a6fc200a0a0a05550302035000f282100001a22e50050a0a0675008203a000f282100001e1c2500a0a0a01150302035000f282100001a0000000000000000000000000000000000000044";
    Dell_P2421D = "00ffffffffffff0010acfed042343330231e0104a5351e783aad75a9544d9d260f5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000f282100001a000000ff00443634335835330a2020202020000000fc0044454c4c205032343231440a20000000fd00314b1d711c010a202020202020019e020314b14f90050403020716010611121513141f023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e7e3900a080381f4030203a000f282100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc";

    # School projectors
    MZ108 = "00ffffffffffff00170e000000000000001b0103800000782e0000000000000000000021080081c08100818090409500a9c0b3000101023a801871382d40582c450080387400001e000000fd00173d0e4c11000a202020202020000000fc00457874726f6e2048444d490a2000000010000000000000000000000000000001b1020322c04a90202205040203060701230907078301000067030c0000008021e200ea00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040";
  };

  configs = {
    ThinkPad_Internal = {
      enable = true;
      primary = true;
      position = "0x0";
      mode = "1920x1080";
      rate = "60.00";
    };
    ThinkVision = {
      enable = true;
      mode = "1920x1080";
      rate = "60.00";
    };
    Dell_S2417DG = {
      enable = true;
      primary = true;
      mode = "2560x1440";
      rate = "144.00";
    };
    Dell_P2421D = {
      enable = true;
      mode = "2560x1440";
      rate = "60.00";
    };
    MZ108 = {
      enable = true;
      mode = "1920x1080";
      rate = "60.00";
    };
  };
in
{
  config = mkIf cfg.enable {
    programs.autorandr = {
      enable = true;
      hooks = {
        postswitch = {
          "change-background" = "systemctl restart --user wallpaper";
          "notify-dbus" =
            ''${pkgs.libnotify}/bin/notify-send "Profile changed to $AUTORANDR_CURRENT_PROFILE"'';
        };
      };
      profiles = {
        ThinkPad = {
          fingerprint = {
            eDP-1 = fingerprints.ThinkPad_Internal;
          };
          config = {
            eDP-1 = configs.ThinkPad_Internal;
          };
        };
        ThinkVision = {
          fingerprint = {
            eDP-1 = fingerprints.ThinkPad_Internal;
            DP-1 = fingerprints.ThinkVision;
          };
          config = {
            eDP-1 = configs.ThinkPad_Internal;
            DP-1 = configs.ThinkVision // {
              position = "1920x0";
            };
          };
          hooks = {
            postswitch = ''
              ${i3msg} '[workspace="10"]' move workspace to output DP-1
              ${i3msg} '[workspace="11: "]' move workspace to output DP-1
              ${i3msg} '[workspace="12: "]' move workspace to output DP-1
            '';
          };
        };
        Courscant_DoubleDell = {
          fingerprint = {
            DP-0 = fingerprints.Dell_S2417DG;
            DP-4 = fingerprints.Dell_P2421D;
          };
          config = {
            DP-0 = configs.Dell_S2417DG // {
              position = "0x0";
            };
            DP-4 = configs.Dell_P2421D // {
              position = "2560x0";
            };
          };
        };
        MZ108 = {
          fingerprint = {
            eDP-1 = fingerprints.ThinkPad_Internal;
            HDMI-2 = fingerprints.MZ108;
          };
          config = {
            eDP-1 = configs.ThinkPad_Internal;
            HDMI-2 = configs.MZ108;
          };
        };
      };
    };
  };
}
