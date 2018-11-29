let
  mysqlBackupLocation = "/var/backup/mysql";
  uploadsLocation = "/var/uploads";
  linodeInfo = { pkgs, lib, ... }: {
    deployment.targetEnv = "none";
    deployment.targetHost = "elrond";
    deployment.targetPort = 2222;

    # Linode configuration.nix
    networking.usePredictableInterfaceNames = false;
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "without-password";
    services.openssh.ports = [ 2222 ];
    services.ntp.enable = true;
    time.timeZone = "America/Los_Angeles";
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
    fileSystems."${mysqlBackupLocation}" = { device = "/dev/sdc"; fsType = "ext4"; };
    fileSystems."${uploadsLocation}" = { device = "/dev/sdd"; fsType = "ext4"; };
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
    services.mysqlBackup.location = "${mysqlBackupLocation}";
    # Run the backup on the first Saturday of every month at 6PM
    services.mysqlBackup.calendar = "Sat *-*-1..7 18:00:00";

    systemd = {
      timers."mysql-backup-long-storage" = {
        description = "Mysql backups backup timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "Sat *-*-1..7 17:00:00"; # Run every Saturday at 5PM
          AccuracySec = "5m";
          Unit = "mysql-backup-long-storage.service";
        };
      };
      services."mysql-backup-long-storage" = {
        description = "Mysql backups backup service";
        enable = true;
        serviceConfig = {
          User = "root";
          PermissionsStartOnly = true;
        };
        script = ''
          find ${mysqlBackupLocation} -type f -name '*.gz' -print0 | \
          xargs -0 ${pkgs.bash}/bin/bash -c 'for filename; do cp -a "$filename" "$filename.`date +%s`"; done' ${pkgs.bash}/bin/bash
        '';
      };
    };

    # Enable NGinx status page for longview even if another page is set as default.
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
