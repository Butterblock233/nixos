# languages.nix
# packages for programming languages
{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    bun
    nodejs
    # deno
    # pnpm

    pixi
    uv
    cargo
    python3
    rustup
    gcc
    clang
    clang-tools

  ];
}
