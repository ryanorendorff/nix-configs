{ prefix ? "", pkgs, ... }:

{
  "${prefix}ssh/ssh_config" = {
    text = ''
      Host *
        SendEnv LANG LC_*
      Host ${pkgs.mine.nixDocker.hostname}
        Port 3022
        User root
        IdentityFile /etc/nix/docker_rsa
        HostName 127.0.0.1
    '';
  };
}