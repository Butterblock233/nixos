# Basic packages for system and daily use
{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
    # Necessary system packages
    git
    vim
    wget
    gcc
    clang
    clang-tools
    gnupg
    age
    chezmoi
    nixfmt-rfc-style
    cargo
    python3
    gnumake

    # Packages for daily use
    just
    fish
    pnpm
    nushell
    pixi
    uv
  ];
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      ## Put here any library that is required when running a package
      ## ...
      ## Uncomment if you want to use the libraries provided by default in the steam distribution
      ## but this is quite far from being exhaustive
      ## https://github.com/NixOS/nixpkgs/issues/354513
      # (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
    ];
  };
  nixpkgs.config.allowUnfree = true;
}
