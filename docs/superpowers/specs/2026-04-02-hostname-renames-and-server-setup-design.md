# Design: Hostname Renames and Headless Server Setup

## Purpose
Standardize hostnames across the infrastructure and introduce a new headless server host (**Fornax**) with a refactored, CLI-focused base configuration.

## Scope
1.  **Refactor `modules/systems.nix`**: Create a clean `ry.base` for CLI/Server use.
2.  **Rename Existing Hosts**: Update directory names and Nix keys for Desktop, Laptop, VM, and Mac.
3.  **Add New Host**: Create `Fornax`, a headless server for media services.

## Architectural Changes

### 1. Refactored Aspect Hierarchy (`modules/systems.nix`)
- **`ry.base` (New)**: Fundamental CLI-only aspects.
    - `network`, `programs`, `security`, `services`, `system`, `secrets`, `memory`, `bootloader`, `terminal`, `shell`, `editor`, `development`, `packages`.
- **`ry.workstation-base` (Refactored)**: Adds minimal GUI/Desktop support.
    - Includes `ry.base`, plus: `bluetooth`, `audio`, `wayland`, `greetd`, `virtualization`, `hardware`, `media-apps`.
- **`ry.workstation` (Existing)**: Full desktop experience.
    - Includes `ry.workstation-base`, plus: `niri`, `plasma`, `noctalia`, `browser`, `discord`, `catppuccin`, `scripts`, `home-services`, `gaming`.

### 2. Host Identity Map (`modules/user.nix`)
| New Hostname | Former Name | Architecture | Purpose |
| :--- | :--- | :--- | :--- |
| **Praxis** | desktop | x86_64-linux | Primary workstation |
| **Sputnik** | laptop | aarch64-linux | Mobile workstation |
| **Tabula** | vm | x86_64-linux | Virtualized testing |
| **Umbra** | mac | aarch64-darwin | Apple Silicon support |
| **Fornax** | (New) | x86_64-linux | Headless Nixarr server |

## Components

### New Files
- `modules/hosts/fornax/default.nix`: Server configuration including `ry.base` and `ry.nixarr`.
- `modules/hosts/fornax/_hardware-configuration.nix`: Placeholder for server hardware setup.

### Modified Files
- `modules/systems.nix`: Aspect refactoring.
- `modules/user.nix`: Host registration and architecture mapping.
- All host `default.nix` files: Update `den.aspects.<name>` keys.

### Directory Renames
- `modules/hosts/desktop` → `modules/hosts/praxis`
- `modules/hosts/laptop` → `modules/hosts/sputnik`
- `modules/hosts/vm` → `modules/hosts/tabula`
- `modules/hosts/mac` → `modules/hosts/umbra`

## Implementation Plan
1.  **Refactor Systems**: Split `ry.base` and `ry.workstation-base` in `modules/systems.nix`.
2.  **Move Directories**: Use `git mv` to rename host folders.
3.  **Update Registry**: Edit `modules/user.nix` with new names and add `Fornax`.
4.  **Update Host Files**: Search and replace `den.aspects.<old>` with `den.aspects.<new>` in renamed folders.
5.  **Initialize Fornax**: Create the Fornax host module with `ry.base` and `ry.nixarr`.

## Verification Strategy
- **Nix Evaluation**: Run `nix flake check` or evaluate a specific host output (e.g., `nix eval .#nixosConfigurations.praxis.config.networking.hostName`).
- **Config Integrity**: Verify `fornax` lacks GUI components by checking its included modules.
