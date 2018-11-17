{
  # Name of our deployment
  network.description = "Exmormon Servers";
  # Enable rolling back to previous versions of our infrastructure
  network.enableRollback = true;

  cesletterbox-server = import ./servers/cesletterbox-server.nix;
  jod-server = import ./servers/jod-server.nix;
}
