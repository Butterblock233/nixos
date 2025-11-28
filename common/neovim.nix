{
  unstablePkgs,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Language Servers
    gopls
    basedpyright
    rust-analyzer
    lua-language-server
    nil # Language Server for `Nix`

    xmake
    cmake
  ];
  # 将默认编辑器设置为 neovim
  environment.variables = {
    EDITOR = "nvim";
  };
  programs.nix-ld.enable = true;
}
