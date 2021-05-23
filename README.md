# NixOS Configuration

[![builds.sr.ht status](https://builds.sr.ht/~sumner/infrastructure/commits/.build.yml.svg)](https://builds.sr.ht/~sumner/infrastructure/commits/.build.yml)
[![HealthCheck Status](https://healthchecks.io/badge/b8bf9b9d-b4bb-4c92-b546-1c69a0/BpOIMYGi.svg)](https://healthchecks.io/projects/8384107b-0803-48b3-bd99-7702d1214ca5/checks/)

This repository contains the NixOS configuration for my personal computers and
servers.

You can find my Home Manager Config here:
https://git.sr.ht/~sumner/home-manager-config

## Hosts

* Personal Computers
  * coruscant: custom desktop
  * jedha: ThinkPad T580
  * mustafar: Samsung Galaxy Chromebook
* Servers
  * bespin: Linode VPS (random infra)
    * Personal Websites
    * [Airsonic](https://airsonic.github.io)
    * [Bitwarden RS](https://github.com/dani-garcia/bitwarden_rs)
    * [GoAccess](https://goaccess.io/)
    * [Isso](https://posativ.org/isso/)
    * [Syncthing](https://syncthing.net)
    * [Xandikos](https://www.xandikos.org/)
* Praesitlyn: Linode VPS (communication services)
    * [Murmur for Mumble](https://www.mumble.info/)
    * [Synapse](https://github.com/matrix-org/synapse)
      * [Heisenbridge](https://github.com/hifi/heisenbridge)
* Nevarro: Linode VPS (bots and such)
    * [Synapse](https://github.com/matrix-org/synapse)

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
4. Run `sudo nixos-rebuild switch --upgrade`.

## Goals

* Infrastructure as code
* Immutable infrastructure (as much as possible)
* Everything backed up to B2
* Everything backed up to onsite location

### Uptime

* Can blow away all servers (but not data) and restore in under an hour
* Can restore all data within one day after catastrophic failure (everything
  goes down, including data)

  * From local backup: 1 day
  * From B2: 2 days

## Backup Strategy

I am using [Restic](https://github.com/restic/restic) to backup everything on my
server, and all of my important documents are stored in Syncthing, which is
backed up from my server.
