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
  virtualisation.containers.enable = true;
}
