self: super: {
  appConfigs = import ./default.nix {
    pkgs = self;
  };
}