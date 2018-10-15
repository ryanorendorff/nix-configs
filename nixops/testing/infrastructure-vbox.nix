{
  helloserver = { pkgs, ... }: {
    deployment.targetEnv = "virtualbox";
    deployment.virtualbox.memorySize = 1024; # megabytes

    deployment.virtualbox.disks.disk1.baseImage = pkgs.callPackage ../images/virtualbox {};
  };
}
