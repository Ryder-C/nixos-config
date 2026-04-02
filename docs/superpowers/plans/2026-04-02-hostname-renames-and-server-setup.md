# Hostname Renames and Fornax Server Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Standardize hostnames (Praxis, Sputnik, Tabula, Umbra) and introduce a new headless server host (Fornax) with a refactored "base" aspect.

**Architecture:**
- Refactor `modules/systems.nix` to separate CLI fundamentals into a `ry.base` aspect.
- Rename existing host directories and update their `den.aspects.<name>` keys.
- Update `modules/user.nix` with the new hostnames and the new `fornax` host.
- Rename host-specific aspects (`niri-desktop` -> `niri-praxis`, etc.) for consistency.

**Tech Stack:** NixOS, Flakes, Nix, Den, Jujutsu (jj).

---

### Task 1: Refactor `modules/systems.nix`

**Files:**
- Modify: `modules/systems.nix`

- [ ] **Step 1: Extract `ry.base` and refactor `ry.workstation-base`**

```nix
{ry, ...}: {
  ry = {
    # Fundamental CLI-only aspects (Server, VM, Desktop)
    base.includes = [
      ry.network
      ry.programs
      ry.security
      ry.services
      ry.system
      ry.secrets
      ry.memory
      ry.bootloader
      ry.terminal
      ry.shell
      ry.editor
      ry.development
      ry.packages
    ];

    # Base workstation aspects (adds minimal GUI/Desktop)
    workstation-base.includes = [
      ry.base
      ry.bluetooth
      ry.audio
      ry.wayland
      ry.greetd
      ry.virtualization
      ry.hardware
      ry.media-apps
    ];

    # Full desktop aspects (extends base)
    workstation.includes = [
      ry.workstation-base

      ry.niri
      ry.plasma
      ry.noctalia
      ry.browser
      ry.discord
      ry.catppuccin
      ry.scripts
      ry.home-services
      ry.gaming
    ];
  };
}
```

- [ ] **Step 2: Create new jj revision and describe**

Run: `jj new && jj describe -m "refactor: extract ry.base aspect in systems.nix"`

### Task 2: Rename Host Directories

**Files:**
- Rename: `modules/hosts/desktop` -> `modules/hosts/praxis`
- Rename: `modules/hosts/laptop` -> `modules/hosts/sputnik`
- Rename: `modules/hosts/vm` -> `modules/hosts/tabula`
- Rename: `modules/hosts/mac` -> `modules/hosts/umbra`

- [ ] **Step 1: Perform directory renames using jj mv**

```bash
jj mv modules/hosts/desktop modules/hosts/praxis
jj mv modules/hosts/laptop modules/hosts/sputnik
jj mv modules/hosts/vm modules/hosts/tabula
jj mv modules/hosts/mac modules/hosts/umbra
```

- [ ] **Step 2: Create new jj revision and describe**

Run: `jj new && jj describe -m "chore: rename host directories to new hostnames"`

### Task 3: Rename Host-Specific Aspects

**Files:**
- Modify: `modules/aspects/niri/default.nix`
- Modify: `modules/aspects/greetd.nix`

- [ ] **Step 1: Update Niri aspect keys**

```nix
# modules/aspects/niri/default.nix
# Replace ry.niri-desktop with ry.niri-praxis
# Replace ry.niri-laptop with ry.niri-sputnik
```

- [ ] **Step 2: Update Greetd aspect keys**

```nix
# modules/aspects/greetd.nix
# Replace ry.greetd-desktop with ry.greetd-praxis
# Replace ry.greetd-laptop with ry.greetd-sputnik
```

- [ ] **Step 3: Create new jj revision and describe**

Run: `jj new && jj describe -m "refactor: rename host-specific aspects to match new hostnames"`

### Task 4: Update Host Configurations

**Files:**
- Modify: `modules/hosts/praxis/default.nix`
- Modify: `modules/hosts/sputnik/default.nix`
- Modify: `modules/hosts/tabula/default.nix`
- Modify: `modules/hosts/umbra/default.nix`

- [ ] **Step 1: Update Praxis (desktop) config**
  - Change `den.aspects.desktop` to `den.aspects.praxis`.
  - Change `ry.niri-desktop` to `ry.niri-praxis`.
  - Change `ry.greetd-desktop` to `ry.greetd-praxis`.

- [ ] **Step 2: Update Sputnik (laptop) config**
  - Change `den.aspects.laptop` to `den.aspects.sputnik`.
  - Change `ry.niri-laptop` to `ry.niri-sputnik`.
  - Change `ry.greetd-laptop` to `ry.greetd-sputnik`.

- [ ] **Step 3: Update Tabula (vm) config**
  - Change `den.aspects.vm` to `den.aspects.tabula`.

- [ ] **Step 4: Update Umbra (mac) config**
  - Change `den.aspects.mac` to `den.aspects.umbra`.

- [ ] **Step 5: Create new jj revision and describe**

Run: `jj new && jj describe -m "refactor: update host configurations with new aspect names"`

### Task 5: Update Host Registry

**Files:**
- Modify: `modules/user.nix`

- [ ] **Step 1: Update host names and add Fornax**

```nix
# modules/user.nix
    hosts = {
      x86_64-linux.praxis.users.ryder = {};
      aarch64-linux.sputnik.users.ryder = {};
      x86_64-linux.tabula.users.ryder = {};
      aarch64-darwin.umbra.users.ryder = {};
      x86_64-linux.fornax.users.ryder = {};
    };
```

- [ ] **Step 2: Create new jj revision and describe**

Run: `jj new && jj describe -m "feat: update host registry with new names and add fornax"`

### Task 6: Create Fornax Host

**Files:**
- Create: `modules/hosts/fornax/default.nix`
- Create: `modules/hosts/fornax/_hardware-configuration.nix`

- [ ] **Step 1: Create Fornax hardware placeholder**

```nix
# modules/hosts/fornax/_hardware-configuration.nix
{...}: {
  # Placeholder hardware configuration for Fornax
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  nixpkgs.hostPlatform = "x86_64-linux";
}
```

- [ ] **Step 2: Create Fornax main configuration**

```nix
# modules/hosts/fornax/default.nix
{ry, ...}: {
  den.aspects.fornax = {
    includes = [
      ry.base
      ry.nixarr
      ry.tailscale
    ];

    nixos = {pkgs, ...}: {
      imports = [./_hardware-configuration.nix];
      
      # Headless server optimizations
      networking.firewall.enable = true;
      services.openssh.enable = true;
    };
  };
}
```

- [ ] **Step 3: Create new jj revision and describe**

Run: `jj new && jj describe -m "feat: add fornax server host configuration"`

### Task 7: Verification

- [ ] **Step 1: Evaluate Praxis hostname**
Run: `nix eval .#nixosConfigurations.praxis.config.networking.hostName`
Expected: `"praxis"`

- [ ] **Step 2: Check Fornax for GUI components**
Run: `nix-store -q --references (nix build .#nixosConfigurations.fornax.config.system.build.toplevel --no-link --print-out-paths) | grep -iE "plasma|niri|greetd"`
Expected: (empty)
