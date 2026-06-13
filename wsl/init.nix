# init.nix
# main entrance of wsl config
{
	username,
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
    ../common/vituralization.nix
  ];
  users.users.${username} = {
    createHome = true;
    description = "";
    extraGroups = [
      "wheel"
    ];
    group = "users";
    home = "/home/${username}";
    isNormalUser = true;
  };
  i18n = {
    defaultLocale = "zh_CN.UTF-8";

  };
  # hardware.nvidia.enabled = true;
  hardware.nvidia-container-toolkit = {
    enable = false;
    suppressNvidiaDriverAssertion = true;
  };
}
