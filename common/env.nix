{
  config,
  lib,
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
  networking =
    let
      proxy = "127.0.0.1:2080";
    in
    {
      proxy.httpsProxy = proxy;
      proxy.httpProxy = proxy;
      proxy.default = proxy;
      proxy.noProxy = "";
    };
}
