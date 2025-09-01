let
  users = {
    nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5m3EP0r/ndk2A+7gA1gSbge3CVM+B3fXEKZWG3fVT Voltage15312@outlook.com";
  };
  systems = {
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5m3EP0r/ndk2A+7gA1gSbge3CVM+B3fXEKZWG3fVT Voltage15312@outlook.com";
  };
in
{
  "anthropic.env.age".publicKeys = [users.nixos systems.wsl];
  "github-token.age".publicKeys = [users.nixos systems.wsl];
  "database-password.age".publicKeys = [users.nixos systems.wsl];
  "anthropic-auth-token.age".publicKeys = [users.nixos systems.wsl];
}
