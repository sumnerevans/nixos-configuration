# Repository guidance

This file applies throughout Sumner's personal NixOS configuration repository.
Use the imports and outputs in `flake.nix` as the source of truth for active
configurations; the README and older host files contain historical information.

## Commit messages

Always use [Scoped Commits](https://scopedcommits.com/):
`<scope>: <description>`. For changes across multiple areas, use a shared scope
or comma-separated scopes.

## Never activate a generation

Never run `nixos-rebuild switch`, `nixos-rebuild boot`, `nixos-rebuild test`,
`home-manager switch`, `colmena apply`, `colmena apply-local`, or another command
that activates or deploys a generation on a real machine. Verify configuration
changes through evaluation or non-activating builds, then give the user the
activation command to run themselves. End-to-end verification is not a reason
to activate a generation.

## Active configurations and import paths

The flake targets `x86_64-linux` and has two configuration paths:

- `nixosConfigurations.scarif` and `nixosConfigurations.mustafar` import
  `nixos/modules`, their respective `nixos/hosts/<host>` directory, and the Home
  Manager NixOS module. Each wires `home-manager.users.sumner` to
  `home-manager/host-configurations/<host>.nix`. Home Manager shares system
  packages through `useGlobalPkgs` and `useUserPackages`; there is no standalone
  `homeConfigurations` output.
- `colmenaHive` is made from `nixos/colmena.nix`. Its defaults import the same
  `nixos/modules` tree. The active server is `morak`, tagged `hetzner` and
  `ashburn`, with its host module and deployment keys configured in the hive.
  This path does not import Home Manager.

`nixos/modules/default.nix` declares `hostCategory` (`laptop` or `server`) and
`ramSize`. Shared laptop/server behavior is gated with `lib.mkIf` on
`hostCategory`. Follow existing option and import patterns when adding modules;
creating a file alone does not include it in a configuration.

`coruscant`, `jedha`, and `tatooine` are not wired into the current flake
outputs. The root `configuration.nix` is also inactive and references an absent
`modules` directory. Do not use these as current setup templates.

## Where changes belong

- `flake.nix`: inputs, package overlays, host wiring, formatter, and dev shell.
  `flake.lock` records dependency revisions; avoid unrelated lock-file updates.
- `nixos/hosts/<host>/`: machine-specific system settings and services. Scarif
  and Morak import tracked `hardware-configuration.nix` files; Mustafar keeps
  hardware settings directly in `default.nix`. Only the root
  `/hardware-configuration.nix` is ignored. Preserve host-specific devices and
  filesystem UUIDs rather than copying them between machines.
- `nixos/modules/`: shared system configuration, with `programs/`, `services/`,
  `users/`, laptop/server settings, and virtualization. Service modules define
  shared nginx, backup, and healthcheck behavior. User definitions and SSH
  public keys live in `users/`; users are managed with `mutableUsers = false`.
- `nixos/hosts/morak/`: server applications; `default.nix` connects them to
  shared services.
- `home-manager/home.nix`: base user identity, state version, and imports of
  `modules/` and `programs/`. Active per-host profiles import this file and set
  desktop toggles, keybindings, packages, and other host overrides.
- `home-manager/modules/`: user configuration grouped by tool or feature.
  Register shared modules in `default.nix`.
- `home-manager/programs/default.nix`: the general user package list and basic
  program enablement; development tools also have `modules/devtools.nix`.
- `notes/`: historical operational notes, not the active configuration graph.

Keep machine-specific fixes in host files and reusable behavior in shared
modules. Preserve `system.stateVersion` and `home.stateVersion` unless a task
explicitly calls for a reviewed state migration; they are not dependency versions.

## Desktop details worth checking before editing

Both active laptops enable Hyprland and DankMaterialShell (DMS). Only Scarif
explicitly enables niri.

Within `home-manager/modules/window-manager/`:

- `hyprland.nix`, `niri.nix`, and `wayland.nix` configure compositors and session
  integration. `niri-config.kdl` supplies the niri configuration.
- `dms.nix` imports the upstream shell, calendar, and plugin modules.
  `dms-settings.nix` supplies shell settings; `dms-plugins/offlinemsmtp/`
  contains a local widget.
- `default.nix` configures GTK/Qt theming and GSettings schema visibility.
  GTK CSS imports DMS-generated `dank-colors.css`; `dms.nix` also sets
  `GSETTINGS_SCHEMA_DIR` on the user service. Read the comments and relevant git
  history before changing theme synchronization or session environment handling.

The `niri` package is overridden in `flake.nix` to a pinned upstream PR commit
with custom source/vendor hashes and build adjustments. Inspect that overlay
before assuming behavior matches the nixpkgs package.

`nixpkgs` follows `nixos-unstable`, DMS follows `stable`, and `dcal` and
`dms-plugin-registry` do not specify branches. Several inputs are the author's
own projects; inspect their overlays and usage before changing package supply.

## Secrets and local environment

`secrets/` is gitignored and has its own Git repository when checked out locally;
it is not a submodule of this repository. Do not copy its contents into tracked
files or diagnostic output. Colmena references restic key files under
`/etc/nixos/secrets/` through `deployment.keys`.

`.envrc` loads restic credentials from `secrets/` and may fail without them.
Use `nix develop` for the flake's development tools without sourcing `.envrc`.

## Validation and formatting

Run commands from the repository root. Choose checks appropriate to the change:

- Inspect a laptop option: `nix eval .#nixosConfigurations.<host>.config.<path>`.
- Evaluate a laptop's system derivation:
  `nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`.
- Plan a laptop build: `nixos-rebuild dry-build --flake .#<host>`.
- Build without activation: `nixos-rebuild build --flake .#<host>`.
  Here `<host>` is `scarif` or `mustafar`; Morak belongs to the Colmena hive.
- Check the flake without building checks: `nix flake check --no-build`.
  Use `nix flake check` when building checks is appropriate. Neither replaces
  validation of the specific host or behavior being changed.
- Format Nix: `nix fmt` uses `pkgs.nixfmt-tree`. Review its diff and avoid
  unrelated formatting changes.
- Run CI's lint hooks: `pre-commit run --all-files`. For a focused change,
  use `pre-commit run --files <changed-files>`.

Evaluation and builds may fetch inputs or write to the Nix store; they do not
activate the resulting system. Report any unavailable dependencies or evaluation
failures, and distinguish successful evaluation from a completed build.

The checked-in CI workflow is `.github/workflows/lint.yaml`. Its pre-commit hooks
check trailing whitespace (excluding Markdown and Vim), final newlines, YAML,
and large added files; it does not build NixOS. There is no dedicated flake
`checks` output or project test suite defined here. Documentation-only changes
need whitespace/content checks, not system builds.

Follow `.editorconfig`: UTF-8, LF line endings, final newline, and two-space
indentation. Review `git diff --check` and the final diff before finishing;
preserve unrelated working-tree changes.
