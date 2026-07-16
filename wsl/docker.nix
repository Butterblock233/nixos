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

  virtualisation.docker = {
    enable = true;
    # enableNvidia = true; # deprecated
    daemon.settings = {
      features.cdi = true;
      proxies =
        let
          proxy = "http://127.0.0.1:2080";
        in
        {
          http-proxy = proxy;
          https-proxy = proxy;
          no-proxy = "";
        };
    };
	# Fix port-forwarding timeout error by disabling iptables
    #
    # Potential Risks of disabling iptables:
    # 1. Loss of Real Client IP: Containers will see 'docker-proxy' (usually 172.17.0.1)
    #    as the source IP for all incoming traffic, which breaks IP-based rate limiting.
    # 2. Host Firewall Bypass: Local firewall rules (like UFW or NixOS firewall) might
    #    no longer block port exposures unless bound explicitly (e.g., -p 127.0.0.1:port:port).
    # 3. CPU & Latency Overhead: Under high-concurrency or heavy throughput workloads,
    #    frequent context-switching in user-space (docker-proxy) will increase CPU usage.
    # 4. Broken Network Isolation: Inter-container isolation between different custom
    #    bridge networks is bypassed since Docker cannot inject drop/reject rules.
    extraOptions = "--iptables=false";
  };
  virtualisation.containers.enable = true;
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
