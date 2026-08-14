# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical rule: never activate a generation

**Never run `nixos-rebuild switch`, `nixos-rebuild boot`, `home-manager switch`, `colmena apply`, or any other command that activates/deploys a new generation on a real machine.** After making config changes, verify with a read-only command (see below) and tell the user to run the activation command themselves. Do not run it "just to check" even if asked to verify something end-to-end.

## What this repo is

Sumner's personal NixOS flake configuration, managing both laptops (via `nixos-rebuild`, with integrated Home Manager) and servers (via Colmena). See `README.md` for the current host list and backup strategy.

## Commands

- Evaluate/build without activating: `nixos-rebuild dry-build --flake .#<host>` or `nixos-rebuild build --flake .#<host>` (host = `scarif` or `mustafar`, from `flake.nix`'s `nixosConfigurations`).
- Check the whole flake evaluates: `nix flake check`.
- Evaluate a single option/attribute: `nix eval .#nixosConfigurations.<host>.config.<path>`.
- Format Nix files: `nix fmt` (uses `pkgs.nixfmt-tree`, set as `flake.nix`'s `formatter`).
- Lint (what CI runs, `.github/workflows/lint.yaml`): `pre-commit run --all-files` (trailing-whitespace, end-of-file-fixer, check-yaml, check-added-large-files — see `.pre-commit-config.yaml`).
- Dev shell with deployment tooling (colmena, git-crypt, pass, etc.): `nix develop` (or via `.envrc`/direnv, already wired with `use flake`).
- Server deploys go through Colmena, not `nixos-rebuild`: `colmena apply` / `colmena apply-local`, hive defined in `nixos/colmena.nix`. (Still don't run this yourself — same rule as above.)

## Architecture

### Two deployment paths, one module tree

- **Laptops** (`scarif`, `mustafar`): `nixosConfigurations` in `flake.nix`, built with `nixos-rebuild`. Home Manager runs as an integrated NixOS module (`useGlobalPkgs`/`useUserPackages` = true), so system and user config activate together.
- **Servers** (`morak`, defined via the Hetzner tag in `nixos/colmena.nix`): built into `colmenaHive` in `flake.nix` and deployed with Colmena, which does *not* pull in Home Manager — servers are NixOS-only.
- Both paths import the same `./nixos/modules` tree, gated by the `hostCategory` option (`"laptop"` | `"server"`, set per-host) and per-module `lib.mkIf`/imports (e.g. `nixos/modules/laptop.nix`, `nixos/modules/server.nix`).

### `nixos/` layout

- `nixos/hosts/<name>/`: hardware-specific config for one machine (imports `hardware-configuration.nix`, which is gitignored and generated per-machine — never commit one from another host).
- `nixos/modules/`: shared system config, imported by every host via `nixos/modules/default.nix`. Split into `programs/`, `services/` (nginx, restic, healthchecks), `users/` (SSH pubkeys + user definitions, `mutableUsers = false`), `laptop.nix`, `server.nix`, `virtualisation.nix`.
- `nixos/colmena.nix`: Colmena hive `defaults` + per-server `deployment` blocks (target host, tags, `deployment.keys` for secrets pulled from `secrets/`).

### `home-manager/` layout

- `home-manager/home.nix`: base profile imported by every host's user config; sets `home.stateVersion`, username/homeDirectory, and imports `home-manager/modules` + `home-manager/programs`.
- `home-manager/host-configurations/<host>.nix`: per-host overrides (imports `../home.nix` then adds host-specific window manager settings, keybinds, packages, symlinks, etc.). This is the file wired into `flake.nix`'s `home-manager.users.sumner` for each `nixosConfigurations` entry.
- `home-manager/modules/`: shared user-level config (shell, git, neovim, email, syncthing, etc.), imported via `home-manager/modules/default.nix`.
- `home-manager/modules/window-manager/`: Hyprland/niri + DMS (DankMaterialShell — a Quickshell-based Wayland shell with Material You theming). `dms.nix` wires the `programs.dank-material-shell` Home Manager module (from the `dms` flake input) and its plugins; `dms-settings.nix` is the full DMS settings blob (theme, bar layout, etc.) passed through as-is. GTK/Qt theming (`gtk.gtk3/gtk4.extraCss` importing DMS's generated `dank-colors.css`, `xdg.systemDirs.data` for GSettings schema visibility) lives in `default.nix` in this directory — see git history/commit messages here before changing theme-sync behavior, since the interaction between DMS's matugen theming, home-manager-managed GTK config, and systemd-user environment propagation is easy to silently break.

### Secrets

`secrets/` is a separate, gitignored, locally-managed directory (its own git history, not a submodule of this repo) holding the age/restic/API-key material referenced by `deployment.keys` in `nixos/colmena.nix` and by `.envrc` (restic backup credentials for direnv). It is not present unless explicitly checked out/unlocked on the machine.

### Flake inputs of note

- `nixpkgs`: `nixos-unstable`, with a local overlay in `flake.nix` patching `niri` to an upstream PR branch — check there before assuming `niri` behavior matches release nixpkgs.
- Several inputs (`webfortune`, `menucalc`, `mdf`, `tracktime`, `offlinemsmtp`, `mailnotify`) are the author's own flakes, exposed as package overlays in `flake.nix`.
- `dms`, `dcal`, `dms-plugin-registry`: DankMaterialShell and its calendar/plugin-registry companions, tracked on their `stable` branches.
