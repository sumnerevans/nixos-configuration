{ pkgs, ... }: {
  users.users.root = {
    shell = pkgs.zsh;

    # Allow all of my computers to SSH in.
    openssh.authorizedKeys.keys = (import ./sumner-ssh-pubkeys.nix)
      ++ (import ./server-pubkeys.nix) ++ [
        # Allow GitHub to SSH in for deploys of websites and server upgrades.
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDamZGBail/SYG9MObIjN8CdUtXYmH+C/xeKVkbnLQ/L1bWYKnjBbPbQnNbghGP8SoNyl7xGOqeDjLC/qq7lznSF+rEp9Dn1NSz/R86Bu+/NtQmUX+NXfL1MApVjOd3wrAUVq4VV1kwBB9hDzViLSA+kJACw1P0oIRt79i/5OUpe9RpbJmgzKs9XXlZmtJWmYiOg4bH3pqjX1yg/Kxk/1j5DBjA3p3F1IZIU9eReIDMAhFL1QXxu240K8nfs4GT/85Qr/c32Hc0llql2ygOU4O1IHi0bVd4K71yPhBnr9KAAXW0M9I9SGgxArCIW/dh6YREKwXgKFnsucffjauBlzkBLSJgE1BmDB0WeaW/dMOHfFE9u+gTyPqvJq/Vu/+ENZK765VZnCc9/k7BEshWpHQvdvH3f2O9vU4Wyaryh7ecAGtWFJYQvaOIOgbdEN649PjWPUt7sRWSEpx6c0wMu+SpFtaV9mAnsHr1SEsby5YJ9G+zopJRrHXJT1MLdijP2n0= GitHub"

        # GitHub nixos-configuration deploy
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDH6br5D4RKQGkzhpLLrhDf7YsvjOeWlIx0YIfHeQZu+1vLhH3dJn2P6QvOdqbVE8Tpk7uPCdBNY6sxDFgkDbVvGd0Zs4uh1YrImJAaqwCNw3X9K1R8taQ3kV3KRrMDw1C8+H3h62TtmYDZUjNDMrTA6C3A9FTHYmlUs5HwDZ3pnH2OgVX4k/UiOcJwtKDAhQtXklXpB9V8MqrmejBeNFdpwgexsU+cRr6VpqPNutkMbZTrizEAmQ7oU2LkrvFCD1Qo+nUB5h5v50dTyVc0aRHlIsAt3ZPUPl9XvxGBwNUAAIIyKtzhWOw1mWQuOCwBYnx1u2qExqd+3P4OLielrFHeIOeY2PdWLRzMJ9m5AkobZSxCUho0QCSt8gpl7ITjB14jDFoHGNC/y5pLWu60vLuPA+fZ07MgyzTjf9ZwsXP4upBG3e+NjY+pL1vubXAtJqe6YAo6iahAZyB0xmfTCAlPw4vbu21VYSmpK2/ugonms7Xk1qDsYkHAwsqay02xs8= sumner@github-actions"
      ];
  };
}
