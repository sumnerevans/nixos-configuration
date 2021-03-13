# NixOS Configuration

This repository contains the NixOS configuration for my personal computers.

## Installation Instructions

```
.----------------------------------------------------------------------------.
| WARNING:                                                                   |
|                                                                            |
| Don't install somebody else's NixOS configs. Use them as inspiration, but  |
| don't actually just blindly copy.                                          |
'----------------------------------------------------------------------------'
```

To install this configuration,

1. Clone this repository to `/etc/nixos` on a NixOS system.
2. Create a new host configuration in the `host-configurations` folder.
3. Source the host configuration from `hardware-configuration.nix`.
4. Run `sudo nixos-rebuild switch`.
