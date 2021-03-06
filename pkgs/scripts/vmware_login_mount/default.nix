{ pkgs, config, ... }:

pkgs.writeScript "vmware_login_mount" ''
  #!/usr/bin/env bash
  ME=$(whoami)
  if [ "root" = "$ME" ]; then
    mkdir -p /mnt/vmware/{downloads,projects,${pkgs.my.username},wallpapers}
    mkdir -p /mnt/{googledrive,googledrivezillow}
    ${pkgs.open-vm-tools}/bin/vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/downloads /mnt/vmware/downloads
    ${pkgs.open-vm-tools}/bin/vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/googledrive /mnt/googledrive
    ${pkgs.open-vm-tools}/bin/vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/googledrivezillow /mnt/googledrivezillow
    ${pkgs.open-vm-tools}/bin/vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/projects /mnt/vmware/projects
    ${pkgs.open-vm-tools}/bin/vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/${pkgs.my.username} /mnt/vmware/${pkgs.my.username}
    ${pkgs.open-vm-tools}/bin/vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/wallpapers /mnt/vmware/wallpapers
    if [[ ! -e ${pkgs.my.directories.home}/wallpapers ]]; then ln -s /mnt/vmware/wallpapers ${pkgs.my.directories.home}/wallpapers; fi;
    mount -a
  else
    echo "Run this script as root"
  fi
''
