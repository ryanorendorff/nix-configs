{
  # Name of our deployment
  network.description = "Exmormon Servers";
  # Enable rolling back to previous versions of our infrastructure
  network.enableRollback = true;

  combined-server = import ./servers/combined-server.nix;
}
