
{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Language Servers
    neovim
    gopls
    basedpyright
    rust-analyzer
    lua-language-server
    nil

    xmake
    cmake
  ];
  # 将默认编辑器设置为 neovim
  programs.nix-ld.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
}
