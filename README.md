# NixOS
Personal NixOS configuration. Currently support WSL.

## Deploy for wsl
```sh
# prepare packages
nix-shell -p just git
# build via just(recommend)
just wsl

# or use
sudo nixos-rebuild switch --flake .#wsl
```
