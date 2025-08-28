{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
    git
    vim
    wget
    neovim
    gcc
    fish
    gnupg
    age
    chezmoi
    nixfmt-rfc-style
    cargo
    python3

    just
    gnumake
    pnpm
    nushell
    zoxide
    fzf
    ripgrep
    fastfetch
  ];
  # 将默认编辑器设置为 neovim
  environment.variables.EDITOR = "nvim";
  environment.variables.SHELL = "fish";
  programs.nix-ld.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.tmux = {
    enable = true;
  };
  programs.clash-verge = {
    enable = false;
  };
}
