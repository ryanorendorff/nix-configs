{
  # Name of our deployment
  network.description = "Ken's Blog Pages";
  # Enable rolling back to previous versions of our infrastructure
  network.enableRollback = true;

  exploring-blog = import ./servers/exploring-blog-server.nix;
}
