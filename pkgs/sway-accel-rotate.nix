{ lib, pkgs }: with pkgs;
buildGoModule rec {
  pname = "sway-accel-rotate";
  version = "master";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "sway-accel-rotate";
    rev = version;
    sha256 = "09m36l56zpwz8hl29dq55q7hmqyi9za2i3sa7yvddkxk0823c5ln";
  };

  vendorSha256 = "1m881s9vp4rsg7pajh03f204dqyn44hld0lgfnypz5gfhrzbs69c";
}
