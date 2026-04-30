# Neptuno-beta Customization Roadmap

## Project Overview
Neptuno-beta is an opinionated Bluefin-based operating system that combines:
- **Bluefin DX** (Developer Experience) as the base layer
- **Niri** (Wayland-native tiling window manager) as the primary WM
- **DankMaterialShell (DMS)** as the shell/interface for Niri
- **GNOME** retained as a backup/fallback option

This roadmap outlines the phased implementation to transform the base neptuno-beta template into a fully functional, developer-focused OS.

## Goals
- [ ] Create a stable, daily-driver OS with Niri+DMS as primary interface
- [ ] Maintain GNOME as a fully functional backup option
- [ ] Inherit Bluefin's robust build system and package management
- [ ] Provide excellent out-of-box developer experience
- [ ] Keep system minimal and performant
- [ ] Follow Universal Blue/Bluefin best practices

## Non-Goals
- [ ] Replace all GNOME applications (many will remain as defaults)
- [ ] Remove Bluefin's core infrastructure (just, brew, flatpak systems)
- [ ] Deviate significantly from atomic update principles
- [ ] Break compatibility with Fedora Bootc ecosystem

---

## Implementation Phases

### Phase 0: Foundation & Preparation
*Objective: Verify baseline and prepare development environment*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 0.1 | Validate current template builds correctly | N/A (test build) | ⬜ |
| 0.2 | Set up local development environment | N/A | ⬜ |
| 0.3 | Create validation test suite (basic boot + WM start) | N/A | ⬜ |
| 0.4 | Document current package list for comparison | N/A | ⬜ |

### Phase 1: Bluefin Base Layer Integration
*Objective: Incorporate Bluefin's core base packages and system*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 1.1 | Add Bluefin base packages (~90 packages) | `build/10-build.sh` | ⬜ |
| 1.2 | Implement proper COPR isolation pattern | `build/10-build.sh` | ⬜ |
| 1.3 | Add package exclusions and version handling | `build/10-build.sh` | ⬜ |
| 1.4 | Enable core system services (podman.socket, etc.) | `build/10-build.sh` | ⬜ |
| 1.5 | Validate build with base packages only | N/A (test build) | ⬜ |

### Phase 2: Bluefin DX Layer Integration
*Objective: Add developer tools and container/virtualization support*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 2.1 | Add Bluefin DX packages (~65 packages) | `build/10-build.sh` | ⬜ |
| 2.2 | Add Docker repository and installation | `build/10-build.sh` | ⬜ |
| 2.3 | Add VS Code repository and installation | `build/10-build.sh` | ⬜ |
| 2.4 | Implement ROCm handling (non-NVIDIA only) | `build/10-build.sh` | ⬜ |
| 2.5 | Enable DX services (docker.socket, libvirt, etc.) | `build/10-build.sh` | ⬜ |
| 2.6 | Validate build with base+DX layers | N/A (test build) | ⬜ |

### Phase 3: Window Manager Transition (GNOME → Niri+DMS)
*Objective: Replace primary WM while keeping GNOME as backup*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 3.1 | Add Niri and DankMaterialShell packages | `build/10-build.sh` | ⬜ |
| 3.2 | Add input-remapper for DMS gestures | `build/10-build.sh` | ⬜ |
| 3.3 | Add Wayland utilities (wl-clipboard, grim, slurp) | `build/10-build.sh` | ⬜ |
| 3.4 | Disable GDM/GNOME default session | `build/10-build.sh` | ⬜ |
| 3.5 | Enable Niri display manager/service | `build/10-build.sh` | ⬜ |
| 3.6 | Validate WM switch (Niri starts by default) | N/A (test build) | ⬜ |

### Phase 4: System Configuration & Tuning
*Objective: Configure Niri, DMS, and system settings*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 4.1 | Add Niri configuration files | Build script (copy to `/etc/niri/`) | ⬜ |
| 4.2 | Add DankMaterialShell theme/config | Build script (copy to DMS config dir) | ⬜ |
| 4.3 | Configure input-remapper for DMS gestures | Build script (copy to `/etc/input-remapper/`) | ⬜ |
| 4.4 | Set up zirconium-inspired wallpapers/theme | Build script (copy to `/usr/share/backgrounds/`) | ⬜ |
| 4.5 | Adjust GTK/icon themes to match DMS aesthetic | Build script (dconf/gsettings) | ⬜ |
| 4.6 | Validate configuration persistence | N/A (test build) | ⬜ |

### Phase 5: Runtime Customizations (User Experience)
*Objective: Enhance post-install experience with CLI tools and apps*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 5.1 | Populate `default.Brewfile` with essential CLI tools | `custom/brew/default.Brewfile` | ⬜ |
| 5.2 | Populate `development.Brewfile` with dev tools | `custom/brew/development.Brewfile` | ⬜ |
| 5.3 | Review/adjust Flatpak list for Niri/DMS focus | `custom/flatpaks/default.preinstall` | ⬜ |
| 5.4 | Add ujust shortcuts for Niri/DMS configuration | `custom/ujust/custom-apps.just` | ⬜ |
| 5.5 | Add ujust shortcuts for input-remapper profiles | `custom/ujust/custom-system.just` | ⬜ |
| 5.6 | Update ujust documentation with neptuno-beta specifics | `custom/ujust/README.md` | ⬜ |

### Phase 6: Validation, Testing & Polish
*Objective: Ensure stability, usability, and documentation completeness*

| Task | Description | Files to Modify | Status |
|------|-------------|-----------------|--------|
| 6.1 | Run full validation pipeline (shellcheck, etc.) | N/A | ⬜ |
| 6.2 | Test boot to login screen (Niri+DMS) | N/A | ⬜ |
| 6.3 | Test GNOME fallback session | N/A | ⬜ |
| 6.4 | Validate package integrity and updates | N/A | ⬜ |
| 6.5 | Test brew bundle installations | N/A | ⬜ |
| 6.6 | Test flatpak installations | N/A | ⬜ |
| 6.7 | Create final documentation in README.md | `README.md` | ⬜ |
| 6.8 | Tag stable release | N/A | ⬜ |

---

## Detailed Implementation Notes

### Package Management Strategy
- **Fedora Packages**: Install in bulk for safety (follow Bluefin pattern)
- **COPR Packages**: Always use `copr_install_isolated()` function
- **Package Exclusions**: Maintain Bluefin's exclusion lists to prevent conflicts
- **Version Handling**: Use `$FEDORA_MAJOR_VERSION` case statements for F42/F43 specifics

### WM Transition Specifics
1. **Keep GNOME Available**: Do not remove `gnome-shell`/`mutter` packages - just don't enable GDM by default
2. **Niri as Default**: Create/`etc/systemd/system/niri.service` or equivalent display manager
3. **Fallback Mechanism**: Ensure GNOME session remains selectable from display manager (if using GDM) or via alternative DM
4. **Input-Remapper**: Critical for DMS gestures - configure swipes/taps for workspace navigation

### Configuration Sources
- **Niri Config**: Adapt from `references/zirconium/mkosi.conf.d/niri-git.conf`
- **DMS Theme**: Extract zirconium's DMS configuration
- **Wallpapers**: Use zirconium's asset collection or create complementary set
- **Input-Remapper**: Create profiles for common DMS gestures (3-finger swipe, etc.)

### Validation Checkpoints
After each phase, verify:
- [ ] Build completes successfully
- [ ] Image boots to login/lock screen
- [ ] Primary WM (Niri) starts by default
- [ ] GNOME session accessible as fallback
- [ ] Core services (podman, docker) functional
- [ ] No regression in package integrity

### Rollback Plan
Each phase should be committed separately with clear conventional commits:
- `feat(base): add bluefin base packages`
- `feat(dx): add bluefin dx layer`
- `feat(wm): implement niri+dms transition`
- etc.

If issues arise, can revert to previous phase commit.

---

## Dependencies & External References

### Primary References
- [Bluefin Repository](https://github.com/ublue-os/bluefin) - Base OS and DX layer
- [Bluefin Common](https://github.com/projectbluefin/common) - Shared configuration
- [Zirconium Repository](https://github.com/zirconium-dev/zirconium) - Niri + DMS implementation

### Key Configuration Files to Study
- `references/bluefin/build_files/base/04-packages.sh` - Base packages
- `references/bluefin/build_files/dx/00-dx.sh` - DX packages and services
- `references/zirconium/mkosi.conf.d/niri-git.conf` - Niri configuration
- Various files in `references/zirconium/mkosi.conf.d/` - DMS and system tweaks

### Tools Required
- Just command runner (`just`)
- Podman or Docker for container builds
- Git for version control
- Basic shell utilities (bash, curl, etc.)

---

## Success Criteria
Neptuno-beta will be considered successfully customized when:
1. [ ] System boots to Niri+DMS by default
2. [ ] GNOME session fully functional as fallback option
3. [ ] Core Bluefin features (just, brew, flatpak, atomic updates) intact
4. [ ] Developer tools (containers, IDEs, debugging) work out-of-box
5. [ ] System updates and rollbacks function correctly
6. [ ] Daily driver capable for general productivity and development work
7. [ ] Documentation reflects actual system state and usage

---

## Next Immediate Action
Begin with Phase 0: Validate current template can build successfully, then proceed to Phase 1 to integrate Bluefin's base packages.

*Last updated: $(date '+%Y-%m-%d')*