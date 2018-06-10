self: super: {
  mine = import ./pkgs.nix {
    pkgs = self;
  };
}