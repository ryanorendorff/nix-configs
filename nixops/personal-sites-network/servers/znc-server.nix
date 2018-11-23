{ config, lib, pkgs, ... }:

{
  # documentation.nixos.enable = false;
  services.nixosManual.enable = false;

  system.stateVersion = "18.09";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowPing = true;

  services.bitlbee = {
    enable = true;
    plugins = [
      pkgs.bitlbee-facebook
      pkgs.bitlbee-steam
    ];
    libpurple_plugins = [
      pkgs.telegram-purple
      pkgs.purple-hangouts
      pkgs.purple-plugin-pack
    ];
  };

  services.znc = {
    enable = true;
    openFirewall = true;
    mutable = true;
    modulePackages = [ pkgs.zncModules.push ];
    # config = {
    #   LoadModule = [ "webadmin" "adminlog" ];
    #   Listener.listener0 = {
    #     SSL = false;
    #   };
    #   User.nocoolnametom = {
    #     Admin = true;
    #     Nick = "nocoolnametom";
    #     AltNick = "nocoolnametom1";
    #     LoadModule = [ "chansaver" "controlpanel" "push" ];
    #     Network.freenode = {
    #       Server = "chat.freenode.net +7000";
    #       LoadModule = [ "sasl" "simple_away" ];
    #       Chan = {
    #         "##typescript" = { Detached = false; };
    #         "#exmormon"    = { Detached = false; };
    #         "#nixos"       = { Detached = false; };
    #         "#node.js"     = { Detached = false; };
    #         "#flowtype"    = { Disabled = true;  };
    #       };
    #     };
    #     Network.im = {
    #       Server = "${config.services.bitlbee.interface} ${config.services.bitlbee.portNumber}";
    #       LoadModule = [ "perform" ];
    #       IRCConnectEnabled = true;
    #       Ident = "doggetto";
    #       Nick = "doggetto";
    #       AltNick = "doggetto";
    #       Chan = {
    #         "&bitlbee" = {};
    #       };
    #     };
    #     Pass.password = {
    #       Method = "sha256";
    #       Hash = "ef8a8a33f57d7ecd12f1446585f4c0e6d5c3ac8b407f25603f029c40c4f68459";
    #       Salt = "h:v4Eoi;Ce7z/GJ9kt1/";
    #     };
    #   };
    #   extraConfig = ''
    #     MaxBufferSize = 9000
    #     Skin          = dark-clouds
    #   '';
    # };
    confOptions = {
      useSSL = false;
      modules = [ "webadmin" "adminlog" ];
      userModules = [ "chansaver" "controlpanel" "push" ];
      extraZncConf = ''
        MaxBufferSize = 9000
        Skin          = dark-clouds
      '';
      userName = "nocoolnametom";
      nick = "nocoolnametom";
      passBlock = ''
        <Pass password>
          Hash   = ef8a8a33f57d7ecd12f1446585f4c0e6d5c3ac8b407f25603f029c40c4f68459
          Method = SHA256
          Salt   = h:v4Eoi;Ce7z/GJ9kt1/
        </Pass>
      '';
      networks = {
        "freenode" = {
          server = "chat.freenode.net";
          port = 7000;
          useSSL = true;
          modules = [ "sasl" ];
          channels = [
            "#typescript"
            "exmormon"
            "flowtype"
            "nixos"
            "node.js"
          ];
          extraConf = ''
            IRCConnectEnabled = true
          '';
        };
        "im" = {
          server = config.services.bitlbee.interface;
          port = config.services.bitlbee.portNumber;
          useSSL = false;
          modules = [ "perform" ];
          channels = [];
          extraConf = ''
            AltNick           = doggetto
            IRCConnectEnabled = true
            Ident             = doggetto
            Nick              = doggetto

            <Chan &bitlbee>
            </Chan>
          '';
        };
      };
    };
  };
}
