{ pkgs, ... }:
{
  users.mutableUsers = false;

  users.users.root = {
    shell = pkgs.zsh;

    # Allow all of my computers to SSH in.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3oHcGiwPtWbee1x+6rKdovw4/CNIyE6MbBqC+irqZnyBLchboLKF+n9Vw9XRZxBPHppcb57oUTjh4gFA8N2vKqjVIacMNHSGFhRXBfUYtaTnmhzNj8sFWPwWpYAneTEe0hFdDKhL63nHZsi3XySh7R+BEIFZrDeyvKH86/GRpQwepVpQV3giqtqDA4GVgla/Zcea5ES1uxEolgDQKszXv8Z8iRUnrohrSAgsanjw6B+41X4qrwVnsStYhVN42tT8I7BM6kko9bdsLf4bg/WqdYDwPA4cbg1RkppqI0k7eBXPNfyaUKquiWz6tmrX5IMeIejjV+2BHgu0Q0iweMtPy41DGX6MaaKawWx5hoLds8fszVK02GUoCee26B8oEX+3TGKF9gj62gDcBOEmjLaGjxFrnk/DEkm3zSahwaIjxsbLK0/tFLh5B9Bha5mNF7tU88JwwJl+Zh3R7vGzHTqfZ7XVvSVSfpOPpVm0q3RSHMvVPSulOI+pTbA6GAQn0dT8= sumner@tatooine"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvBSffkOjq5nzFczPgaC41D5/6w1g1bK94YAAY4mBMVF8wh3aQF62X7FfV4cHM6wgUe2IOWinPZ/imL9+Nu9TsQbGc+mbfLltmZiGiHLqQBJOjMwwodxdkljhPmwUvALemyNiHkJ2yAvnMqSBteJuAv8ayqyYAPbWfRD6zA2N+haHQCSXXqjJTe/rH6ax0rvMWefCxVKKTuxXTfrRSbtGeCB/4QkpJErrItJxYEIkM3/uM4tvMvH/1DewwWP6gxgX+Faq5VrHVcP1qDXQje8ZM/ajRNdvqZv9begUqPQMckpGKmOWRXZV1/WFN4cbkJdTsf+t6iKTp+9lAyrhcOhPEI/C70SoN20/CFZMN8mDVJMxEeVgUmFD3nDpXLpUS0pzbQsbhiyQuwZaHs4uZMczkozMGgKWuy0IswLQhFl/2F25KHC/ogNrJ4d+W7GFnL+w4argNWcXevbHi+/jXiRcgMgGznAWRSc7Rb7+fIuwGxRLaZhRoH7pdaqtZfdK0VpU= sumner@scarif"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6pod+Zrer9WFhlSTMVXFau2ZpNA52lyJ9mzb8dkMBR infrastructure-secrets"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6nQZmkBapOt3/LpNxKFcttlrYQwiV6Ew1jd9JpKrfG sumner.evans@canamtechnologies.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJb4LfOIrcyH3Ur2n+EKbcZEF6qpy2PXIMw1zjVVzaiF sumner@mustafar"
    ];
  };
}
