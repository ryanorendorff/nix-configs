self: super: {
  myFiles = import ./default.nix {
    pkgs = self;
  };
}