{
  pkgs,
  ...
}:
{
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "butter"
    "root"
  ];

  environment.variables = {
    IS_NIXOS = "true";
  };

}
