{ inputs, ... }:
{
  nix.registry = {
    pkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    pkgs-unstable.flake = inputs.nixpkgs-unstable;
  };
}
