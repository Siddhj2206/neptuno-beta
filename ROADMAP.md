# Neptuno Customization Roadmap

## Project Overview

Neptuno (codename "Deinonychus") is an opinionated bootc-based operating system built on:

- **Fedora Silverblue** (via `ublue-os/silverblue-main`) as the base image
- **Niri** (Wayland-native tiling window manager) as the primary WM
- **DankMaterialShell (DMS)** as the shell/interface for Niri
- **GNOME** retained as a fallback session
- **projectbluefin/common** shared layer for bootc/ublue infrastructure

This roadmap tracks what's done, what's in progress, and what remains.

## Goals

- [x] Create a stable, daily-driver OS with Niri+DMS as primary interface
- [x] Maintain GNOME as a fully functional backup option
- [x] Inherit Bluefin's robust build system and package management
- [x] Provide excellent out-of-box developer experience
- [ ] Keep system minimal and performant
- [x] Follow Universal Blue/Bluefin best practices
- [ ] Migrate away from bluefin-specific common layer files

## Non-Goals

- Replace all GNOME applications (many will remain as defaults)
- Remove Bluefin's core infrastructure (just, brew, flatpak, ujust)
- Deviate significantly from atomic update principles
- Break compatibility with Fedora Bootc ecosystem

---

## Implementation Status

### Phase 0: Foundation & Preparation — Done

| Task                                       | Status | Notes                                                                          |
| ------------------------------------------ | ------ | ------------------------------------------------------------------------------ |
| Validate current template builds correctly | ✅     | Builds successfully via CI                                                     |
| Set up local development environment       | ✅     | Justfile + podman                                                              |
| Create validation test suite               | ✅     | CI validation workflows (shellcheck, brewfiles, flatpaks, justfiles, renovate) |
| Document current package list              | ✅     | See phases below                                                               |

### Phase 1: Base Layer — Done

_`build/10-build.sh` + `build/00-image-info.sh`_

| Task                                                | Status | Details                                                                                                                  |
| --------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------ |
| OS identity (image-info, os-release)                | ✅     | `00-image-info.sh`: PRETTY_NAME=Neptuno, ID=neptuno, CODENAME=Deinonychus                                                |
| Bluefin common + shared config rsync                | ✅     | `rsync` from `/ctx/oci/common/shared/` and `/ctx/oci/common/bluefin/`                                                    |
| Custom files (niri, ghostty, systemd units)         | ✅     | `rsync` from `/ctx/custom/files/`                                                                                        |
| Brewfiles, ujust consolidation, flatpak preinstalls | ✅     | Copied to standard locations                                                                                             |
| ~70 Fedora base packages                            | ✅     | chromium, fish, zsh, tmux, fastfetch, just, glow, gum, tailscale, borgbackup, restic, mozc, samba, wireguard, etc.       |
| Tailscale (3rd-party repo)                          | ✅     | Disabled after install                                                                                                   |
| COPR: che/nerd-fonts, ublue-os/packages (uupd)      | ✅     | Using `copr_install_isolated`                                                                                            |
| ~13 excluded packages                               | ✅     | firefox, gnome-software, gnome-terminal-nautilus, cosign, yelp, etc.                                                     |
| fwupd COPR swap                                     | ✅     | From ublue-os/staging                                                                                                    |
| Core system services                                | ✅     | podman-auto-update.timer, ublue-user-setup, brew-setup, dconf-update, tailscaled, ublue-system-setup, flatpak-preinstall |

### Phase 2: DX Layer — Done

_`build/20-dx.sh`_

| Task                        | Status | Details                                                                                                                                                |
| --------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ~65 DX packages from Fedora | ✅     | containers (docker, podman-compose, libvirt, qemu, lxc), dev tools (clang, go, bpftrace, bpftop), ROCm (hip, opencl, smi), android-tools, virt-manager |
| Docker CE (3rd-party repo)  | ✅     | docker-ce + compose + buildx + model plugin                                                                                                            |
| VS Code (3rd-party repo)    | ✅     | Via microsoft yum repo                                                                                                                                 |
| DX services                 | ✅     | docker.socket, podman.socket, swtpm-workaround, libvirt-workaround, neptuno-groups                                                                     |
| Custom systemd units        | ✅     | neptuno-groups (adds wheel to docker/libvirt), swtpm/libvirt SELinux workarounds, docker sysctl, VFIO dracut                                           |

### Phase 3: Window Manager (Niri + DMS) — Done

_`build/30-dms.sh`_

| Task                           | Status | Details                                                                                                        |
| ------------------------------ | ------ | -------------------------------------------------------------------------------------------------------------- |
| Niri, DMS, supporting packages | ✅     | From COPRs: avengemedia/danklinux, avengemedia/dms, yalter/niri                                                |
| Supporting packages            | ✅     | xdg-desktop-portal-gtk, accountsservice, xwayland-satellite, adw-gtk3-theme, qt6 stack, cliphist, wl-clipboard |
| DMS stack                      | ✅     | niri, quickshell-git, matugen, dgop, dsearch, cava, khal, ghostty, dms                                         |
| COPR cleanup                   | ✅     | All 3 COPRs disabled after install (note: not using `copr_install_isolated` — should migrate)                  |
| GTK theming                    | ✅     | Flatpak theme override, adw-gtk3-dark, dark color-scheme                                                       |
| DMS services                   | ✅     | dms wired to niri.service, dsearch enabled globally                                                            |

### Phase 4: System Configuration — Done

_`custom/files/`_

| Task                            | Status | Details                                                                                        |
| ------------------------------- | ------ | ---------------------------------------------------------------------------------------------- |
| Niri configuration              | ✅     | `etc/skel/.config/niri/config.kdl` + includes (binds, colors, layout, alttab, cursor, outputs) |
| Niri local override pattern     | ✅     | `niri/local.kdl` — user overrides survive config refresh                                       |
| DMS module configs              | ✅     | `niri/dms/*.kdl` — binds, colors, layout, alttab, cursor, outputs                              |
| Ghostty terminal config         | ✅     | `etc/skel/.config/ghostty/config` — font, Material 3 theme, keybinds                           |
| DMS environment vars            | ✅     | `etc/skel/.config/environment.d/90-dms.conf` — ELECTRON_OZONE_PLATFORM_HINT, TERMINAL=ghostty  |
| Neptuno group management        | ✅     | `usr/bin/neptuno-groups` — idempotent, version-checked                                         |
| Systemd workarounds             | ✅     | neptuno-groups.service, libvirt-workaround, swtpm-workaround, tmpfiles.d entries               |
| Docker sysctl                   | ✅     | `usr/lib/sysctl.d/docker-ce.conf` — ip_forward=1                                               |
| VFIO dracut config              | ✅     | `usr/lib/dracut/dracut.conf.d/80-vfio.conf`                                                    |
| Input-remapper for DMS gestures | ⬜     | Not implemented yet                                                                            |
| Custom wallpapers/theme         | ⬜     | Not implemented yet                                                                            |

### Phase 5: Runtime Customizations — Partially Done

| Task                                          | Status | Details                                                                                                                                                                   |
| --------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `default.Brewfile`                            | ✅     | bat, eza, fd, ripgrep, gh, lazygit, starship, zoxide, atuin, htop, tmux                                                                                                   |
| `development.Brewfile`                        | ✅     | go, node, uv, rust, cmake, ninja                                                                                                                                          |
| `fonts.Brewfile`                              | ✅     | Fira Code, JetBrains Mono, Meslo LG, Hack, Cascadia Code (all Nerd Font casks)                                                                                            |
| `default.preinstall`                          | ✅     | ~28 Flatpaks: Zen Browser, GNOME Core apps, Flatseal, Warehouse, Ignition, Resources, Impression, Bazaar, DistroShelf, Refine, Gearlever, Pinta, Clapper, adw-gtk3 themes |
| `custom-apps.just`                            | ✅     | install-neptuno-core-flatpaks, neptuno-apps alias, install-neptuno-brew (all 3 Brewfiles)                                                                                 |
| `custom-system.just`                          | ✅     | install-dms-config (interactive with gum + backups), refresh-dms-config, show-dms-config-paths, dms-doctor, dms-check                                                     |
| Update README "What Makes neptuno Different?" | ⬜     | Still says "None added yet"                                                                                                                                               |
| Fix Brewfile "bluepilot" reference            | ⬜     | `default.Brewfile:1` says "bluepilot"                                                                                                                                     |
| Remove third-party repo files after install   | ⬜     | 10-build.sh (tailscale), 20-dx.sh (docker, vscode) — disabled but not removed                                                                                             |
| Migrate 30-dms.sh to `copr_install_isolated`  | ⬜     | Currently manual enable/install/disable                                                                                                                                   |

### Phase 6: Validation, Testing & Polish — Not Started

| Task                                            | Status |
| ----------------------------------------------- | ------ |
| Run full validation pipeline (shellcheck, etc.) | ⬜     |
| Test boot to login screen (Niri+DMS)            | ⬜     |
| Test GNOME fallback session                     | ⬜     |
| Validate package integrity and updates          | ⬜     |
| Test brew bundle installations                  | ⬜     |
| Test flatpak installations                      | ⬜     |
| Update README.md with actual system state       | ⬜     |
| Fix iso/iso.toml placeholder URL                | ⬜     |
| Fix ROADMAP.md `$(date)` template variable      | ⬜     |
| Tag stable release                              | ⬜     |

---

## Known Issues

| Issue                                                                        | File                                  | Severity                 |
| ---------------------------------------------------------------------------- | ------------------------------------- | ------------------------ |
| README "What Makes neptuno Different?" section says "None added yet"         | `README.md:17-33`                     | Medium                   |
| `default.Brewfile:1` references "bluepilot" instead of "neptuno"             | `custom/brew/default.Brewfile:1`      | Low                      |
| `iso/iso.toml` has placeholder `<YOUR_GITHUB_USERNAME>` URL                  | `iso/iso.toml`                        | High (breaks ISO builds) |
| Third-party repo files disabled but not removed (Tailscale, Docker, VS Code) | `build/10-build.sh`, `build/20-dx.sh` | Medium                   |
| `30-dms.sh` doesn't use `copr_install_isolated`                              | `build/30-dms.sh`                     | Low                      |
| Cosign signing enabled in CI but `SIGNING_SECRET` may not be set             | `.github/workflows/build.yml`         | High (breaks CI)         |
| Stale Renovate remote branches in repo                                       | Git                                   | Low                      |

---

## Detailed Implementation Notes

### Package Management Strategy

- **Fedora Packages**: Install in bulk for safety (follow Bluefin pattern)
- **COPR Packages**: Always use `copr_install_isolated()` function (except `30-dms.sh` — needs migration)
- **Third-party repos**: Disable after install, remove repo file (needs cleanup)
- **Package Exclusions**: Maintain exclusion lists to prevent conflicts
- **Version Handling**: Use `$FEDORA_MAJOR_VERSION` case statements for F42/F43 specifics

### WM Transition Specifics

1. **GNOME Available**: gnome-shell/mutter remain installed; GNOME session selectable from GDM
2. **Niri as Default**: DMS service wired to niri.service via `systemctl --global add-wants`
3. **Fallback**: GNOME session remains selectable at GDM login screen
4. **Input-Remapper**: Not yet implemented — DMS gestures are configured via niri binds.kdl instead

### Configuration Architecture

- **System defaults**: `/etc/skel/.config/` — deployed by `ujust install-dms-config`
- **User overrides**: `~/.config/niri/local.kdl` — survives config refreshes
- **Custom files**: `custom/files/` — rsync'd into image root by `10-build.sh`
- **Brewfiles**: `custom/brew/` — copied to `/usr/share/ublue-os/homebrew/`
- **ujust**: `custom/ujust/*.just` — consolidated into `/usr/share/ublue-os/just/60-custom.just`
- **Flatpaks**: `custom/flatpaks/*.preinstall` — copied to `/etc/flatpak/preinstall.d/`

### Validation Checkpoints

After each phase, verify:

- [x] Build completes successfully
- [ ] Image boots to login/lock screen
- [ ] Primary WM (Niri) starts by default
- [ ] GNOME session accessible as fallback
- [ ] Core services (podman, docker) functional
- [ ] No regression in package integrity

---

## Dependencies & External References

### Primary References

- [Bluefin Repository](https://github.com/ublue-os/bluefin) - Base OS and DX layer
- [Bluefin Common](https://github.com/projectbluefin/common) - Shared configuration (`references/common/`)
- [Zirconium Repository](https://github.com/zirconium-dev/zirconium) - Niri + DMS reference implementation

### Key Build Scripts

- `build/00-image-info.sh` — OS identity (image-info.json, os-release)
- `build/10-build.sh` — Base packages, rsync, services
- `build/20-dx.sh` — DX packages, Docker, VS Code, ROCm
- `build/30-dms.sh` — Niri + DMS stack from COPR
- `build/copr-helpers.sh` — `copr_install_isolated()` function

### Tools Required

- Just command runner (`just`)
- Podman for container builds
- Git for version control
- Basic shell utilities (bash, curl, etc.)

---

## Success Criteria

Neptuno will be considered successfully customized when:

1. [ ] System boots to Niri+DMS by default
2. [ ] GNOME session fully functional as fallback option
3. [x] Core Bluefin features (just, brew, flatpak, atomic updates) intact
4. [x] Developer tools (containers, IDEs, debugging) work out-of-box
5. [ ] System updates and rollbacks function correctly
6. [ ] Daily driver capable for general productivity and development work
7. [ ] Documentation reflects actual system state and usage
8. [ ] Bluefin common migration complete (no blanket bluefin rsync)

---

## Bluefin Common Migration Inventory

Source: `projectbluefin/common` → `system_files/bluefin/`
Currently rsync'd wholesale via `build/10-build.sh:29` — goal is to migrate away from the bluefin layer.

### Keep As-Is (already copied to `custom/files/`)

These files are desktop-agnostic and work for Niri without modification.

| File                                                     | Purpose                                                                                         |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `usr/lib/systemd/system/dconf-update.service`            | Runs `dconf update` on boot — needed for GTK apps under Niri                                    |
| `usr/lib/dracut/dracut.conf.d/90-passkeys-tpm.conf`      | Adds FIDO2/TPM2/PKCS11/PCSC to initramfs — hardware security support                            |
| `usr/share/applications/noop.desktop`                    | Prevents GNOME Disks from opening AppImage files — desktop-agnostic workaround                  |
| `usr/share/ublue-os/firefox-config/01-bluefin-global.js` | Forces Firefox WebRender + HW video decode — universal Wayland fix                              |
| `etc/zsh/zshenv`                                         | Zsh early env: disables global compinit, sets PATH — desktop-agnostic                           |
| `etc/zsh/zprofile`                                       | Zsh login: locale, cdpath/fpath/path dedup — desktop-agnostic                                   |
| `etc/zsh/zshrc`                                          | Zsh interactive: completion, history, fuzzy match, brew+starship integration — desktop-agnostic |
| `etc/zsh/zlogin`                                         | Zsh post-login: background-compiles zcompdump for faster startups — desktop-agnostic            |
| `etc/zsh/zlogout`                                        | Zsh logout hook (empty) — desktop-agnostic                                                      |
| `etc/profile.d/uutils.sh`                                | Prepends uutils-coreutils paths if installed via Brew — desktop-agnostic                        |
| `etc/profile.d/open.sh`                                  | `open` alias → `xdg-open` — desktop-agnostic                                                    |
| `usr/share/fish/vendor_functions.d/fish_prompt.fish`     | Fish prompt with container detection — desktop-agnostic                                         |

### Needs Adaptation (must modify before copying to `custom/files/`)

| File                                                            | Purpose                                                               | What to adapt                                                                            |
| --------------------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `usr/share/ublue-os/just/00-entry.just`                         | ujust entry point, imports other just files                           | Change import list to Neptuno's just files                                               |
| `usr/share/ublue-os/just/system.just`                           | Core ujust commands: devmode, dx-group, flatpaks, powerwash, rollback | Replace `bluefin-dx` naming with Neptuno image names; rewrite rollback helper image list |
| `usr/share/ublue-os/just/changelog.just`                        | Shows changelogs from GitHub Releases                                 | Change repo from `ublue-os/bluefin` to Neptuno repo                                      |
| `usr/share/ublue-os/motd/template.md`                           | MOTD banner: image name, commands table, tips, links                  | Replace Bluefin branding/URLs with Neptuno                                               |
| `usr/share/ublue-os/motd/tips/10-tips.md`                       | 26 rotating tips (Bazaar, DistroShelf, Bluefin docs)                  | Rewrite tips for Neptuno ecosystem                                                       |
| `usr/share/ublue-os/motd/env.sh`                                | MOTD environment vars from image-info.json                            | Mostly desktop-agnostic, minor branding tweaks                                           |
| `usr/share/ublue-os/bling/env.sh`                               | Toggle messages for `bluefin-cli` bling                               | Change "bluefin-cli" branding to Neptuno                                                 |
| `usr/share/ublue-os/fastfetch.jsonc`                            | Fastfetch system info config with Bluefin metrics                     | Replace Bluefin metrics, adapt for Neptuno                                               |
| `etc/ublue-os/fastfetch.json`                                   | Points fastfetch to Bluefin logos dir                                 | Point to Neptuno logos directory                                                         |
| `usr/bin/ublue-rollback-helper`                                 | Interactive gum-based bootc switch/rebase tool                        | Rewrite image names/channels for Neptuno                                                 |
| `usr/share/applications/documentation.desktop`                  | Opens docs.projectbluefin.io                                          | Replace URL with Neptuno docs                                                            |
| `usr/share/applications/discourse.desktop`                      | Opens Bluefin GitHub Discussions                                      | Replace URL with Neptuno community                                                       |
| `usr/share/applications/system-update.desktop`                  | Launches `ujust update` in terminal                                   | Change icon ref, concept is reusable                                                     |
| `etc/xdg/mimeapps.list`                                         | Default apps: PDF→Papers, AppImage→noop, Flatpak→Bazaar               | Adapt for Neptuno's app choices; keep AppImage noop                                      |
| `etc/bazaar/curated.yaml`                                       | 516-line Bazaar store layout with CSS and sections                    | Needs Neptuno branding, banners, and app curation                                        |
| `etc/bazaar/blocklist.yaml`                                     | Blocks apps from Bazaar store (VS Code, IDEs, editors)                | Adapt blocklist to Neptuno philosophy                                                    |
| `etc/bazaar/bazaar.yaml`                                        | Bazaar config pointing to host paths                                  | Keep if shipping Bazaar                                                                  |
| `usr/lib/systemd/user/bazaar.service`                           | Autostarts Bazaar in background                                       | Keep if shipping Bazaar                                                                  |
| `usr/lib/tmpfiles.d/bazaar-flatpak.conf`                        | Symlink for Bazaar Flatpak filesystem override                        | Keep if shipping Bazaar                                                                  |
| `usr/share/flatpak/preinstall.d/bazaar.preinstall`              | Forces Bazaar preinstall                                              | Keep if shipping Bazaar                                                                  |
| `usr/share/ublue-os/flatpak-overrides/io.github.kolunmi.Bazaar` | Bazaar Flatpak filesystem override                                    | Keep if shipping Bazaar                                                                  |
| `usr/share/ublue-os/homebrew/system-flatpaks.Brewfile`          | 37 Flatpaks (many GNOME Circle + Bazaar)                              | Cherry-pick; remove GNOME-specific (Extension Manager, etc.)                             |
| `usr/share/ublue-os/homebrew/system-dx-flatpaks.Brewfile`       | DX Flatpaks (Podman Desktop, GNOME Builder, etc.)                     | Cherry-pick; remove GNOME Builder                                                        |
| `usr/share/ublue-os/homebrew/full-desktop.Brewfile`             | 66 curated Flatpak apps via `ujust bbrew`                             | Cherry-pick for Neptuno                                                                  |
| `usr/share/icons/hicolor/scalable/places/*.svg` (5 files)       | Icons for .desktop files and OS identity                              | Create Neptuno-branded versions                                                          |
| `etc/skel/.local/share/flatpak/overrides/com.visualstudio.code` | VS Code Flatpak: Wayland + podman socket access                       | Keep if shipping VS Code Flatpak                                                         |
| `etc/skel/.local/share/flatpak/overrides/com.google.Chrome`     | Chrome Flatpak: app/icon directory access                             | Keep if shipping Chrome Flatpak                                                          |

### Drop Entirely (GNOME Shell / Bluefin branding — not useful for Niri)

| File                                                                         | Why drop                                                         |
| ---------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| `etc/environment`                                                            | Sets `GNOME_SHELL_SLOWDOWN_FACTOR=0.8` — GNOME only              |
| `etc/dconf/db/distro.d/01-bluefin-folders`                                   | GNOME app folder organization                                    |
| `etc/dconf/db/distro.d/02-bluefin-keybindings`                               | GNOME media-keys keybindings                                     |
| `etc/dconf/db/distro.d/03-bluefin-ptyxis-palette`                            | Ptyxis (GNOME terminal) palette                                  |
| `etc/dconf/db/distro.d/04-bluefin-logomenu-extension`                        | GNOME Shell Logo Menu extension config                           |
| `etc/dconf/db/distro.d/05-bluefin-searchlight-extension`                     | GNOME Shell SearchLight extension config                         |
| `etc/dconf/db/distro.d/locks/01-bluefin-locked-settings`                     | Locks GNOME Software updates — irrelevant without GNOME Software |
| `etc/gnome-initial-setup/vendor.conf`                                        | GNOME Initial Setup — not used                                   |
| `usr/share/glib-2.0/schemas/zz0-bluefin-modifications.gschema.override`      | 138 lines of GNOME Shell/dock/extension config                   |
| `usr/share/ublue-os/bluefin-logos/` (12 files: symbols, sixels, PNGs)        | Bluefin mascot branding                                          |
| `usr/share/plymouth/themes/spinner/watermark.png`                            | Bluefin boot splash                                              |
| `usr/share/plymouth/themes/spinner/silverblue-watermark.png`                 | Silverblue boot splash                                           |
| `usr/share/pixmaps/*.png` (7 files)                                          | Bluefin-branded system logos replacing Fedora                    |
| `usr/share/pixmaps/faces/bluefin/` (15 JPGs)                                 | Bluefin user avatar images                                       |
| `usr/share/icons/hicolor/scalable/actions/ublue-logo-symbolic.svg`           | Logo Menu extension icon                                         |
| `etc/skel/.local/share/org.gnome.Ptyxis/palettes/catppuccin-dynamic.palette` | Ptyxis-specific color palette                                    |

---

## Next Immediate Action

Review the migration inventory above. For each file in "Needs Adaptation", decide whether to migrate and adapt it, or drop it. Once decisions are made, implement the selective copy in `build/10-build.sh` replacing the blanket rsync.

_Last updated: 2026-05-03_
