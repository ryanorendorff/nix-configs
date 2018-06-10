{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # ./browse.nix
      ./cron.nix
      ./dev.nix
      ./fonts.nix
      # ./mopidy_config.nix
      # ./music.nix
      ./networking.nix
      ./php.nix
      ./users.nix
      # ./virtualbox.nix
      ./vmware.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "exfat" "ext" ];

  networking.hostName = "nixos";

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    rsync
    tmux
    screen
    unzip
    psmisc
    offlineimap
    stow
    glibcLocales
  ];

  # Hardware
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.zeroconf.publish.enable = true;
  hardware.pulseaudio.tcp = {
    enable = true;
    anonymousClients.allowedIpRanges = [
      "127.0.0.1"
    ];
  };

  # Security
  security.initialRootPassword = "$6$G4kaf6Pg.Q$baOttdistuWWJoUF0kcxgQbRpyIkJ/5vKMS7P33EOkgQvT4da8rRjsaKQ8d.h7xrblNK5Ne5jmzUc.k7z18XS1";

  # Sudo
  security.sudo.wheelNeedsPassword = false;

  # List services that you want to enable:

  # Enable the NTP daemon.
  services.ntp.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Offline IMAP daemon.
  # services.offlineimap.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the i3 Window Manager through auto-logging in tdoggett
  services.xserver.displayManager.auto = {
    enable = true;
    user = "tdoggett";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
