{
  imports = [
    ./sumner.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
}
