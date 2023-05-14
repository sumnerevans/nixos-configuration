# NixOS Configuration

[![Deploy Latest Generation](https://github.com/sumnerevans/nixos-configuration/actions/workflows/build.yaml/badge.svg?branch=master)](https://github.com/sumnerevans/nixos-configuration/actions/workflows/build.yaml)
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
  - **tatooine**: Hetzner Cloud VPS dev box (CPX41) that I use
    [eternalterminal](https://eternalterminal.dev/) to connect to a tmux
    session.

- **Servers**

  - **morak**: Hetzner Cloud VPS (CPX11)

    - Personal Websites
    - [Airsonic](https://airsonic.github.io)
    - [Isso](https://posativ.org/isso/)
    - [Matrix Vacation Responder](https://gitlab.com/beeper/matrix-vacation-responder)
    - [Murmur for Mumble](https://www.mumble.info/)
    - [Synapse](https://github.com/matrix-org/synapse) (sumnerevans.com)
    - [Syncthing](https://syncthing.net)
    - [vaultwarden](https://github.com/dani-garcia/vaultwarden)
    - [Xandikos](https://www.xandikos.org/)

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
