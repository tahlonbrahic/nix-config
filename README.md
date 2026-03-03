# Tahlon's NixOS Configuration

This repository contains a modular NixOS configuration designed to support multiple machines with profile support distributed across those machines.

## Directory Structure

- **`flake.nix`**: The main entry point for the NixOS configurations.
- **`outputs.nix`**: Literally the flake outputs, although it aggregrates through a series of many function calls.
- **`secrets`**: Secures storage for sensitive information (e.g., API keys, passwords).
- **`.sops.yaml`**: SOPS-NIX configuration
- **`LICENSE`**: A standard MIT License for ease of distribution and modification.
- **`README.md`**: This file, which provides an overview of the repository.

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/TahlonBrahic/nix-config.git .
```

2. Define your own configuration in outputs or choose a pre-defined configuration:

nix --extra-experimental-features 'nix-command flakes' run github:LGUG2Z/JeezyVim ./\_disko.nix

If you choose to use an already established configuration it is important to define your hardware specifications as either or a module or vars.

3. Rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Replace `hostname` with the appropriate hostname configured in ./outputs/architecture/src/hostname.nix


### Tips
I personally place my config in /home/{my username}/.config/nixos
and symlink it to /etc/nixos with:

```bash
sudo ln -sf /home/tahlon/.config/nixos /etc/nixos
```
