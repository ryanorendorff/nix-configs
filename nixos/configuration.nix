{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Adds my packages to the scope of this file.
      ../overlays
      # Font Management
      ./fonts.nix
      # User Management
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = pkgs.callPackage ../installList/linuxSystem.nix { };

  # Virtualbox Stuff
  virtualisation.virtualbox.host.enable = true;
  nixpkgs.config.virtualbox.host.enableExtensionPack = true;
  nixpkgs.config.virtualbox.host.addNetworkInterface = true;

  environment.etc = lib.mkMerge([
    pkgs.myFiles.etc.hosts
    pkgs.myFiles.etc.ssh_config
    pkgs.myFiles.etc.trulia_server
    pkgs.myFiles.etc.trulia_api_local
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Hardware
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.zeroconf.publish.enable = true;
  hardware.pulseaudio.tcp = {
    enable = true;
    anonymousClients.allowedIpRanges = [
      "127.0.0.1"
    ];
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";

  # Security
  security.initialRootPassword = "$6$Y38Cw.Nj$KCnCKYw0BCBaRXUlfnAt7ZwWjhiuaPFBAh1sv1hC9qkUH55CJte96YUallWG8mAa391MQmnJYufCGGxPucnO81";

  # Sudo
  security.sudo.wheelNeedsPassword = false;

  # List services that you want to enable:

  # Enable changing keyboard backlight brightness
  services.udev.extraRules = ''
    DEVPATH=="/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chmod 0666 /sys/class/leds/asus::kbd_backlight/brightness"
  '';

  # Enable the Mopidy Music Server.
  services.mopidy = with pkgs.appConfigs.mopidy; {
    inherit extensionPackages;
    inherit configuration;
    enable = false;
  };

  # Enable the NTP daemon.
  services.ntp.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Offline IMAP daemon.
  # services.offlineimap.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Power Management
  services.upower.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Cron Jobs
  services.cron.enable = true;
  services.cron.systemCronJobs = [
    pkgs.myCronJobs.hourlySyncProjects
  ];

  # Enable the i3 Window Manager through auto-logging in tdoggett
  services.xserver.displayManager.auto = {
    enable = true;
    user = "tdoggett";
  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.tapping = false;
  services.xserver.libinput.tappingDragLock = false;
  services.xserver.libinput.disableWhileTyping = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
