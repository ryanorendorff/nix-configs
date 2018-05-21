{
  allowUnsupportedSystem = true;
  allowUnfree = true;
  allowBroken = false;
  allowUnfreeRedistributable = true;

  packageOverrides = pkgs: rec {
    weechat = pkgs.weechat.override {
      extraBuildInputs = [
        pkgs.pythonPackages.websocket_client
        pkgs.pythonPackages.six
      ];
    };
  };
}
