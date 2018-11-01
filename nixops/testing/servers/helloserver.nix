{ config, pkgs, ... }:

let
  cesletterbox = pkgs.callPackage ./apps/cesletterbox {};
in {
  services.nixosManual.enable = false;

  system.nixos.stateVersion = "18.03";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ];
  networking.firewall.allowPing = true;

  services.nginx = {
    enable = true;
    statusPage = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    appendHttpConfig = ''
      add_header X-Clacks-Overhead "GNU Terry Pratchett";
      autoindex on;
    '';
    virtualHosts = {
      "cesletterbox.com" = {
        # forceSSL = true;
        # enableACME = true;
        serverAliases = [ "www.cesletterbox.com" "cesletterbox.com" ];
        root = "${cesletterbox}";
      };
    };
  };
}
