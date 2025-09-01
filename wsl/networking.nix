{ ... }:
{
  networking.useDHCP = true;
  networking.interfaces.eth0.useDHCP = true;

  networking.proxy =
    let
      proxy = "http://127.0.0.1:2080";
    in
    {
      httpsProxy = proxy;
      httpProxy = proxy;
      default = "";
      noProxy = "";
    };
}
