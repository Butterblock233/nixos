{ ... }:
{

  virtualisation.docker = {
    enable = true;
    # enableNvidia = true; # deprecated
    daemon.settings = {
      features.cdi = true;
      cdi-spec-dirs = [ "/etc/cdi" ];
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
