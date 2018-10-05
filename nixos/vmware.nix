{ config, pkgs, ... }:

{
  services.vmwareGuest.enable = true;
  boot.initrd.checkJournalingFS = false;
  boot.extraModprobeConfig = ''
    options snd-intel8x0 ac97_clock=48000
  '';
  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  boot.kernel.sysctl."vm.swappiness" = 60;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "exfat" "ext" ];
  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];
}
