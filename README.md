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
2. Create a `hostname` file containing the desired hostname.
3. Run `sudo nixos-rebuild switch`.
