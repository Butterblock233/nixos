# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a NixOS flake-based configuration for WSL environments. The configuration is modularized into several components:

- **flake.nix**: Main flake configuration using NixOS 25.05, includes home-manager, agenix for secrets, and nixos-wsl
- **wsl/init.nix**: WSL-specific configuration that imports common modules
- **common/**: Shared configuration modules
  - `packages.nix`: System-level packages (git, neovim, development tools)
  - `home.nix`: User-level packages and dotfiles managed by home-manager
  - `env.nix`: Environment variables, proxy settings, and Anthropic API configuration
  - `neovim.nix`: Neovim configuration with language servers (gopls, basedpyright, rust-analyzer, lua-language-server, nil)

## Common Commands

### System Management
```bash
# Apply configuration changes to WSL
just wsl
# Alternative: sudo nixos-rebuild switch --flake .#wsl --impure

# Format Nix files
just format
# Alternative: nixfmt **/*.nix

# Clean up old generations and garbage collect
just cleanup
```

### Development Environment
- Default editor: neovim (accessible via `nvim`, `vi`)
- Default shell: fish
- Package management: Nix flakes with home-manager for user packages
- Language servers available: Go, Python (basedpyright), Rust, Lua, Nix
- `sudo nixos-rebuild switch --flake .#wsl` or `just wsl` to rebuild system
- 


### Tools and MCP:
- mcp-nixos: provide search service of NixOS and home-manager
- fetch: get contents of web resources
### Secrets Management
- Uses agenix for encrypted secrets
- Secret files stored in `secrets/` directory
- API tokens and credentials managed through agenix

### Proxy Configuration
- HTTP/HTTPS proxy configured at 127.0.0.1:2080
- Proxy settings applied system-wide in env.nix

## Key Configuration Details

- NixOS state version: 25.05
- Home Manager state version: 25.05
- User: nixos with home directory at /home/nixos
- Hostname: wsl (for WSL configuration)
- Experimental features enabled: nix-command, flakes

- explain before operations
- home-manager will be built when building nixos system