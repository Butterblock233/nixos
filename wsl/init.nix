# init.nix
# main entrance of wsl config
{
  ...
}:
{
  imports = [
    ../common/neovim.nix
    ../common/packages.nix
    ../common/env.nix
    ../common/remote.nix
    ./networking.nix
    ../common/languages.nix
    ../common/docker.nix
  ];
  users.users.butter = {
    createHome = true;
    description = "";
    extraGroups = [
      "wheel"
    ];
    group = "users";
    home = "/home/butter";
    isNormalUser = true;
  };
}
