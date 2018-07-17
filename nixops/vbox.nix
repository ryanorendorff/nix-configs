let
  pkgsNative = import <nixpkgs> { system = builtins.currentSystem; };
in {
  vmware =
    { config, pkgs, lib, ... }:
    {
      services.nixosManual.enable = false; # Manual building is breaking nixops for some reason right now.
      deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 1024; # megabytes
      deployment.virtualbox.vcpu = 2; # number of cpus

      deployment.virtualbox.disks.disk1.baseImage = pkgsNative.runCommand "virtualbox-nixops-18.03.vmdk" { preferLocalBuild = true; allowSubstitutes = false; }
        ''
          xz -d < ${pkgsNative.fetchurl {
            url = "http://nixos.org/releases/nixos/virtualbox-nixops-images/virtualbox-nixops-18.03pre131587.b6ddb9913f2.vmdk.xz";
            sha256 = "1hxdimjpndjimy40g1wh4lq7x0d78zg6zisp23cilqr7393chnna";
          }} > $out
        '';

      imports = [ ../nixos/configuration.nix ];

      deployment.virtualbox.sharedFolders = {
        tdoggett = {
          hostPath = "/Users/tdoggett";
          readOnly = false;
        };
      };
      fileSystems."/mnt/vbox/tdoggett" = {
        fsType = "vboxsf";
        device = "tdoggett";
        options = [ "rw,uid=1000,gid=100,dmode=777,fmode=777" ];
      };

      boot.supportedFilesystems = [ "exfat" "ext" ];
      boot.kernel.sysctl."vm.swappiness" = 60;
      swapDevices = [
        {
          device = "/swapfile";
          size = 2048;
        }
      ];
    };
}
