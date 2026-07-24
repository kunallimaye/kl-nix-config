# Cross-Platform Single-List Nix Setup

This repository contains a modular Nix environment configuration managed with [Flakes](https://nixos.wiki/wiki/Flakes), [`nix-darwin`](https://github.com/LnL7/nix-darwin), and [`home-manager`](https://github.com/nix-community/home-manager).

## 🚀 Quick Start Commands

Use the included `Makefile` commands to interact with the environment:

| Command | Action |
| :--- | :--- |
| `make syntax-check` | Check Nix syntax and evaluate flake outputs without installing |
| `make rebuild-check` | Dry-run the configuration to see what changes will be made |
| `make rebuild-run` | Apply and activate the configuration on your live system |
| `make update` | Update `flake.lock` to pull latest package revisions |
| `make clean-cache` | Delete old profile generations and optimize disk space |
| `make help` | Show available Makefile commands |

---

## 📁 Repository Structure

* **`flake.nix`**: Flake entrypoint defining system configurations (`mac` for macOS Apple Silicon and `kunall` for Linux).
* **`packages.nix`**: Declarative list of home packages shared across platforms (Go, Rust, Node.js, Python, VS Code, Podman, etc.).
* **`pinned-overlay.nix`**: Custom Nixpkgs overlays for pinning specific tool versions and patches.
* **`Makefile`**: Convenience wrapper for common Nix CLI workflows.

---

## 🛠️ First-Time Setup on macOS

1. Ensure the [Determinate Nix Installer](https://zero-to-nix.com/concepts/nix-installer) is installed.
2. If prompt errors occur during initial setup, move default shell configuration files:
   ```bash
   sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
   sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
   ```
3. Test evaluation:
   ```bash
   make rebuild-check
   ```
4. Apply system configuration:
   ```bash
   make rebuild-run
   ```
