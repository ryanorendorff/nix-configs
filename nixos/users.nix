{ config, pkgs, lib, ... }:

{
  users.mutableUsers = false;

  users.extraGroups.${pkgs.my.username}.gid = 499;
  users.extraUsers.${pkgs.my.username} = {
    isNormalUser = true;
    home = "/home/${pkgs.my.username}";
    description = "Tom Doggett";
    group = pkgs.my.username;
    packages = [ pkgs.git pkgs.stow ];
    extraGroups = [ "wheel" "networkmanager" "users" "audio" "vboxusers" "docker" ];
    uid = 1000;
    hashedPassword = "$6$Zmgjoxw7$UTKTEtSRxVcUK0MmYM2OEDZ6.vtueK2G5FMHlGmpv2swu83PqDf1hM9nhGQ1VQWSUD5CzrXat0YdTYzNzwo.H/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlKRzkkOsGyYRGYx65QhYFPNtm2KM5ghlVX8rUkWwh47fIeAmdVRRgcXpDuITxO9BSe5jDhxyhGa6rLfkNLsHHgV5F0nT5XNIRZyf1UcSgIhZmBI0uX471Q6VFXsZisTlKKO/wkJljf4Ov7euqyAAyzUG2UjZcbMxu0Ggp8A2mazog14ux2Jr1al2CYPzunhZwMmnabRsIaHLXN4VIBfDIDMqO4zKKpED314G3yCzdIn8V4dAEiTx6ZXowvG3WisqVrQiXb0hjqEqsDF2eJyAsnx4X2UUIG//07ZPte5wma/cFniiHFF4UTN9JQdBiw3XigLxl/sbHbi20Xty+qXaF nocoolnametom@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHRGHHW723oTlQDBZ9HTvzwUOv7jYuOzb4o4m9H69eJJojtZn6GhBzaCexYwAEOrQjXipxh6gbht+On5i1RqNmoOKvHWBVhsrffafIQ1iCpzmRSmyNnSD5LND+Uf0DCwaJrLv4IbR+U69ovO9TCcz/VovIZfRN027MD1mP94DzwpG2b5NfRfM6YBXQKfifOZ+LOzuLVOGhpaN7At2Mj6qomFHYtDuF51SrzHh0boMLEtEtH4ZXhe68f94IchUUgVgU7776nXDPDXNdcS6MYa58lc5JHVWRAhNk8upQQrfg2pXYI7qfHGbnSIj+lRSDCbQ05GYsdrgkV1OKjGFkaHTl tdoggett@trulia.com"
    ];
  };

  # I haven't yet figured out how to have this work and have a unified system
  # imports = [
  #   "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  # ];
  # home-manager.users.tdoggett = import ../home.nix { config = config.home-manager; inherit pkgs; inherit lib; };
}
