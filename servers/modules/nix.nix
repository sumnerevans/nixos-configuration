{
  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "45min";
      options = "--delete-older-than 30d";
    };

    settings.download-buffer-size = 4294967296; # 4 GiB
  };
}
