{
  vmware =
    { config, pkgs, lib, ... }:
    {
      imports = [ ../nixos/configuration.nix ];

      deployment.targetHost = "192.168.186.130";

      fileSystems."/" =
        { device = "/dev/disk/by-label/nixos";
          fsType= "ext4";
        };

      services.vmwareGuest.enable = true;
      boot.initrd.checkJournalingFS = false;
      boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
      boot.extraModprobeConfig = ''
        options snd-intel8x0 ac97_clock=48000
      '';
      boot.blacklistedKernelModules = [ "snd_pcsp" ];
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
