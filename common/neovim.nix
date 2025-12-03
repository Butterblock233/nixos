{
  unstablePkgs,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Language Servers

    # golang
    gopls
    # Python
    basedpyright
    # rust
    rust-analyzer
    # lua
    lua-language-server
    stylua
    # Language Server for `Nix`
    nil
    # C++
    xmake
    cmake
    clang-tools

  ];
  # 将默认编辑器设置为 neovim
  environment.variables = {
    EDITOR = "nvim";
  };
}
