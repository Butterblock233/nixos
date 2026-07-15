# provide an docker backend for Docker/Podman in Windows host
{ ... }: {
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [ 2222 ];

  users.users.himalian = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "render"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5m3EP0r/ndk2A+7gA1gSbge3CVM+B3fXEKZWG3fVT Voltage15312@outlook.com"
    ];

  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5m3EP0r/ndk2A+7gA1gSbge3CVM+B3fXEKZWG3fVT Voltage15312@outlook.com"
    ];
  };
}
