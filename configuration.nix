{ config, pkgs, ... }:
{
  # Import a bunch of things.
  imports = [
    # Include the results of the hardware scan. This is autogenerated.
    ./hardware-configuration.nix

    # Other stuff
    ./fonts.nix
    ./networking.nix
    ./tmpfs.nix
    ./programs/default.nix
    ./services/default.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable powertop for power management.
  powerManagement.powertop.enable = true;

  # Keep the system up-to-date automatically.
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "monthly";
    channel = https://nixos.org/channels/nixos-unstable;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.sumner = {
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/sumner";
    hashedPassword = "$6$p0WfA2vae4b5QahY$/qCwuUV.tVZEajIq7xcFUqcVD6iXAOK0kVPxki27flq4NXNn1XTTbH4s0RQedyKArAg1D2.Y0V0xQF.B/TME90";
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel" # Enable 'sudo' for the user.
    ];

    # Allow all of my computers to SSH in.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDasJXb4uvxPh0Z1NLa22dTx42VdWD+utRMbK0WeXS6XakIipx1YPb4yqbtUMJkoTLuFW/BUAEXSiks+ARD3Lc4K/iJeHHXbYvgklvr5dAPV6P2KtiVRZ+ipSLv1TF+al6hVUAnp4PPUQTv+3ZRA64QFrCAt26A7OnxKlowyW2KZVSqAcWPdQEbCdwILRCRIWTpbSj1rDeEsnvmu1G+Id5v7+uybQ+twBHbGpfYH7yWYLEhDtRyYu5SgnBcEh0bqszEgt+iLH/XzTQJILKdDaf4x8j/FJ9Px7+VQVfc+yADZ882ZsFzaxlmn7ndstAssmSSsHfRmNye0exIJqGXdxUfpF3w4h5qnR/0AJM7ljtXuDNOlOxflX0WvZinhhOJ/gF3No8sCXG/OcqlMNyrWd+vpJH4f9Xa0PTOn3Qpltq3YxWOZrWopUIDZw5jSsgLpLfC2NtGE/p5nEFnJCmMqrXPDY7dYS+65qYYjWXCzY3d9i3offwIQtV780Gu1VvT/zE= sumner@coruscant"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPswA82WA6tHR8rccfVrmBflIfC9SmZpG1Y+Gr8WPxcMy/fdlOt8zV4FveUA466pu9oOsZKmuz8WlP2RK96mhhf/CB68QyPAObo6NyIKQgDC97owRGpNtGTUw4bWdGT+9VKDcuoJdK0cI1dY3jrhIgKL43rOfBnhJfDEBWpRJFof79AfN+Zcs1hTprCjPbiHdXuc7E+uhvxdKfoC2lTDYneVNFUBubcH6SSCJ27AZURPca2aSMkWgGCVTom1ch4Y8jZ5e6Kg0pNZW8LQoLC/kzdwC/f8DHXPFSFipVP5jJ6qtXWm0WCY62nsuV6GyphmmC2H25gV3GefD1ano2pJixRMfj8Muvwm+XKXD7GqmprEKMr0KZjkMGKq144T31TWG/LXkRKuGmHf9wNx4gmFTr6stG30nDYlhaMf/jpeoSAPV9o48x6DZqgd+ukQHKG/uXIYU9gj6OtFOi5bJQp+64P1pBc78942PdnvgC4Bk2sqOyj8nPFeFZKAURctib38U= sumner@jedha"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9J5GLv9e/k1yDFw/pWyGFcHeRaLMI3j22ihQfGKgfX9Kl3X/R2s5+4a4c98PbPeeO0WlFvu0JiwhT1MLb5Kk5iLxVf8C32kNPQ0kLpa+g/L7YSsvYMThUF8qcLhw0imDVEye4gKrKc6uQDwaCr/Rd+93elfeZ+OQj34czWV1vf4Tnpiad7WZ0IVklN5GQTdVTVPDzjiLaKgl/f3E/wv7DYibDUwwdCBWxo+4RJ9QbSwbgxQykLe3TOydPbwyIk5jmGSdNjtxhT4223lVZICBD2AYf23ERPZz/VtPZvF4qv+55C9YjoatAlW68esKTV3X2qV7K19RbeD58N8Yk16SMgs/HyLzXk4L1pPVNMZVAKX7nqNWnn12VMzHa+DJsEBvcnzwaGsBqEuf3fPzP7Isp9IKwQcBEF+mM1UgGRx8OA5tYt9vOnXtYJG+nOkupfga/fT1Zl9Imao+B0Gz1gG6ywM6bxUr5kkjvuQggc4J6pTslG11IQrnBll7k04vKDtM= sumner@mustafar"
    ];
  };

  # Environment variables
  environment.homeBinInPath = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
