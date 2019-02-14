{ config, pkgs, ... }:

{
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;
  boot.extraModprobeConfig = ''
    options snd-intel8x0 ac97_clock=48000
  '';
  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "exfat" "ext" ];
  services.xserver.videoDriver = "virtualbox";
  fileSystems."/mnt/vbox/sdcard" = {
    fsType = "vboxsf";
    device = "sdcard";
    options = [ "rw,uid=1000,gid=100,dmode=777,fmode=777" ];
  };
  fileSystems."/mnt/vbox/${pkgs.my.username}" = {
    fsType = "vboxsf";
    device = pkgs.my.username;
    options = [ "rw,uid=1000,gid=100,dmode=777,fmode=777" ];
  };
  fileSystems."/mnt/vbox/windows" = {
    fsType = "vboxsf";
    device = "windows";
    options = [ "rw,uid=1000,gid=100,dmode=777,fmode=777" ];
  };
}
