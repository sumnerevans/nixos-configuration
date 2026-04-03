{
  programs.kitty = {
    enable = true;
    autoThemeFiles = {
      light = "AtomOneLight";
      dark = "Carbonfox";
      noPreference = "AtomOneLight";
    };
    settings = {
      scrollback_lines = 100000;
      enable_audio_bell = false;
      update_check_interval = 0;
      allow_hyperlinks = true;
    };
  };
}
