let
  linodeInfo = { pkgs, lib, ... }: {
    deployment.targetEnv = "none";
    deployment.targetHost = "elrond";
    deployment.targetPort = 2222;

    # Linode configuration.nix
    networking.usePredictableInterfaceNames = false;
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "without-password";
    services.openssh.ports = [ 2222 ];
    environment.systemPackages = with pkgs; [ wget vim inetutils mtr sysstat ];
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;

    # Linode hardware-info.nix
    imports = [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];
    boot.initrd.availableKernelModules = [ "virtio_pci" "ahci" "sd_mod" ];
    boot.kernelParams = [ "console=ttyS0,19200n8" ];
    boot.loader.grub.device = "nodev";
    boot.loader.timeout = 10;
    boot.loader.grub.extraConfig = ''
      serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial;
    '';
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
    fileSystems."/" = { device = "/dev/sda"; fsType = "ext4"; };
    swapDevices = [ { device = "/dev/sdb"; } ];
    nix.maxJobs = lib.mkDefault 1;

    # Nixops-specific stuff
    services.longview = {
      enable = true;
      apiKey = import ../../keys/private/longview_api_key.nix;
      mysqlUser = "linode-longview";
      mysqlPassword = import ../../keys/private/longview_api_key.nix;
    };
    services.mysql.initialScript = pkgs.writeScript "longviewMySQLpermissions.sql" ''
      CREATE USER IF NOT EXISTS 'linode-longview'@'localhost' IDENTIFIED BY '${import ../../keys/private/longview_api_key.nix}';
      FLUSH PRIVILEGES;
    '';
    services.nginx.virtualHosts."localhost" = {
      serverAliases = [ "127.0.0.1" ];
      locations = {
        "/nginx_status" = {
          extraConfig = ''
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            allow ::1;
            deny all;
          '';
        };
      };
    };
  };
in {
  exploring-blog = linodeInfo;
}
