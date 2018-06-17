self: super: {
  myCronJobs = import ./default.nix {
    pkgs = self;
  };
}