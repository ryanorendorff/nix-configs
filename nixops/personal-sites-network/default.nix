{
  # Name of our deployment
  network.description = "My Personal Pages";
  # Enable rolling back to previous versions of our infrastructure
  network.enableRollback = true;

  professional-page-server = import ./servers/professional-page-server.nix;
}
