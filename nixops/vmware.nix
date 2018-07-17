{
  vmware =
    { config, pkgs, lib, ... }:
    {
      imports = [ ../nixos/configuration.nix ];
      
      services.nixosManual.enable = false; # Manual building is breaking nixops for some reason right now.

      deployment.targetHost = "192.168.186.130";

      fileSystems."/" =
        { device = "/dev/disk/by-label/nixos";
          fsType= "ext4";
        };

      # We put the vmware stuff in here because we can't eclare the dployment as a "vmware" enviroment
      services.vmwareGuest.enable = true;
      boot.initrd.checkJournalingFS = false;
      boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
      boot.extraModprobeConfig = ''
        options snd-intel8x0 ac97_clock=48000
      '';
      boot.blacklistedKernelModules = [ "snd_pcsp" ];
      boot.loader.grub.enable = true;
      boot.loader.grub.version = 2;
      boot.loader.grub.device = "/dev/sda";
      boot.supportedFilesystems = [ "exfat" "ext" ];
      boot.kernel.sysctl."vm.swappiness" = 60;
      swapDevices = [
        {
          device = "/swapfile";
          size = 2048;
        }
      ];

      nix.maxJobs = lib.mkDefault 1;
    };
}
