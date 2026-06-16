{ ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
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
  };
  virtualisation.docker.rootless.daemon.settings = {
    features = {
      cdi = true;
    };
    cdi-spec-dirs = [
      "/etc/cdi"
      "/var/run/cdi"
    ];
  };
  virtualisation.containers.enable = true;
}
