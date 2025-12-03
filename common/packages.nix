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
}
