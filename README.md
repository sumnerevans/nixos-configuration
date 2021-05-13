# NixOS Configuration

[![builds.sr.ht status](https://builds.sr.ht/~sumner/infrastructure/commits/.build.yml.svg)](https://builds.sr.ht/~sumner/infrastructure/commits/.build.yml)
[![HealthCheck Status](https://healthchecks.io/badge/b8bf9b9d-b4bb-4c92-b546-1c69a0/BpOIMYGi.svg)](https://healthchecks.io/projects/8384107b-0803-48b3-bd99-7702d1214ca5/checks/)

This repository contains the NixOS configuration for my personal computers and
servers.

**NOTE:** I am currently migrating my servers to use this repository. They
currently still use the old repo: https://git.sr.ht/~sumner/infrastructure

## Hosts

* Personal Computers
  * coruscant: custom desktop
  * jedha: ThinkPad T580
  * mustafar: Samsung Galaxy Chromebook
* Servers
  * bespin: Linode VPS
    * [Airsonic](https://airsonic.github.io)
    * [Bitwarden RS](https://github.com/dani-garcia/bitwarden_rs)
    * [GoAccess](https://goaccess.io/)
    * [Isso](https://posativ.org/isso/)
    * [Murmur for Mumble](https://www.mumble.info/)
    * [Quassel](https://quassel-irc.org/)
    * [Synapse](https://github.com/matrix-org/synapse) for
      [Matrix](https://matrix.org)
    * [Syncthing](https://syncthing.net)
    * [The Lounge](https://thelounge.chat/)
    * [Wireguard](https://www.wireguard.com/)
    * [Xandikos](https://www.xandikos.org/)

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
