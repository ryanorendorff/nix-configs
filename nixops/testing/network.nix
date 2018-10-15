{
  # Name of our deployment
  network.description = "HelloWorld";
  # Enable rolling back to previous versions of our infrastructure
  network.enableRollback = true;

# It consists of a single server named 'helloserver'
  helloserver = import ./servers/helloserver.nix;
}
