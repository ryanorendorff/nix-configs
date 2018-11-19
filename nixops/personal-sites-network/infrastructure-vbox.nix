let
  vboxInfo = { pkgs, ... }: {
    deployment.targetEnv = "virtualbox";
    deployment.virtualbox.memorySize = 1024; # megabytes
    # deployment.virtualbox.headless = true;

    deployment.virtualbox.disks.disk1.baseImage = pkgs.callPackage ../images/virtualbox {};
  };
in {
  professional-page-server = vboxInfo;
}
