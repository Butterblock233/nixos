# init.nix
# main entrance of wsl config
{
  username,
  inputs,
  ...
}:
{
  imports = [
    ../common/neovim.nix
    ../common/packages.nix
    ../common/env.nix
    ./remote.nix
    ./networking.nix
    ../common/languages.nix
    ../common/vituralization.nix
    ../common/registy.nix
    ./drivers.nix
  ];
  wsl = {
    enable = true;
    defaultUser = "${username}";
    useWindowsDriver = true;
  };
  users.users.${username} = {
    createHome = true;
    description = "";
    extraGroups = [
      "wheel"
      "docker"
    ];
    group = "users";
    home = "/home/${username}";
    isNormalUser = true;
  };
  i18n = {
    defaultLocale = "zh_CN.UTF-8";

  };
}
