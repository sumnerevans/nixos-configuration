{ config, pkgs, ... }: let
  chromeCommandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";
in
{
  environment.systemPackages = with pkgs; [
    (chromium.override { commandLineArgs = chromeCommandLineArgs; })
    (google-chrome.override { commandLineArgs = chromeCommandLineArgs; })
    elinks
    firefox
    w3m
  ];
}
