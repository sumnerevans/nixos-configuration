{
  services.syncthing = {
    enable = true;
    extraOptions = [ "--gui-address=http://0.0.0.0:8384" ];
  };
  systemd.user.services.syncthing.Unit = {
    After = [
      "graphical-session.target"
      "udiskie.service"
    ];
    Requires = [
      "graphical-session.target"
      "udiskie.service"
    ];
    PartOf = [ "graphical-session.target" ];
  };
}
