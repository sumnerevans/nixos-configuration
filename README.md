# NixOS Configuration

[![builds.sr.ht status](https://builds.sr.ht/~sumner/nixos-configuration/commits/.build.yml.svg)](https://builds.sr.ht/~sumner/nixos-configuration/commits/.build.yml)
[![HealthCheck Status](https://healthchecks.io/badge/b8bf9b9d-b4bb-4c92-b546-1c69a0/BpOIMYGi.svg)](https://healthchecks.io/projects/8384107b-0803-48b3-bd99-7702d1214ca5/checks/)

This repository contains the NixOS configuration for my personal computers and
servers.

You can find my Home Manager Config here:
https://github.com/sumnerevans/home-manager-config/

## Hosts

- **Personal Computers**

  - **coruscant**: custom desktop
  - **jedha**: ThinkPad T580
  - **mustafar**: Samsung Galaxy Chromebook

- **Servers**

  - **bespin**: Linode VPS (non-realtime critical infrastructure)

    - [Syncthing](https://syncthing.net)

  - **morak**: Hetzner Cloud VPS (CPX11)

    - Personal Websites
    - [Airsonic](https://airsonic.github.io)
    - [GoAccess](https://goaccess.io/)
    - [Isso](https://posativ.org/isso/)
    - [Murmur for Mumble](https://www.mumble.info/)
    - [pr-tracker](https://git.sr.ht/~sumner/pr-tracker)
    - [Synapse](https://github.com/matrix-org/synapse) (sumnerevans.com)
    - [Syncthing](https://syncthing.net)
    - [vaultwarden](https://github.com/dani-garcia/vaultwarden)
    - [Xandikos](https://www.xandikos.org/)

  - **kessel**: Hetzner Cloud VPS (CCX12, primary Synapse infrastructure)

    - nevarro.space website
    - [quotesfilebot](https://gitlab.com/jrrobel/quotes-file-bot)
    - [standupbot](https://sr.ht/~sumner/standupbot)
    - [Synapse](https://github.com/matrix-org/synapse) (nevarro.space)
      - [Heisenbridge](https://github.com/hifi/heisenbridge)
      - [LinkedIn Matrix](https://gitlab.com/beeper/linkedin)

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
2. Unlock the repo using `git-crypt unlock /path/to/git-crypt/key`.
3. Create a new host configuration in the `host-configurations` folder.
4. Source the host configuration from `hardware-configuration.nix`.
5. Run `sudo nixos-rebuild switch --upgrade`.

## Goals

- Infrastructure as code
- Immutable infrastructure (as much as possible)
- Everything backed up to B2
- Everything backed up to onsite location

### Uptime

- Can blow away all servers (but not data) and restore in under an hour
- Can restore all data within one day after catastrophic failure (everything
  goes down, including data)

  - From local backup: 1 day
  - From B2: 2 days

## Backup Strategy

I am using [Restic](https://github.com/restic/restic) to backup everything on my
server, and all of my important documents are stored in Syncthing, which is
backed up from my server.
