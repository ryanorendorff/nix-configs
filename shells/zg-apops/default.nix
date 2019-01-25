with import <nixpkgs> { };

pkgs.mkShell rec {
  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    git
    vim
    openssl
    terraform-full
    ansible
    docker
    python2
    python2Packages.virtualenv
    python2Packages.pip
    python2Packages.cffi
    python2Packages.cryptography
  ] ++ (if pkgs.stdenv.isDarwin then [pkgs.darwin.cctools] else []);

  shellHook = ''
    ${python2Packages.virtualenv}/bin/virtualenv ~/.cache/apopsclienv
    ${python2Packages.pip}/bin/pip install --extra-index-url https://pypi.stage.ap.truaws.com apopscli
  '';
}
