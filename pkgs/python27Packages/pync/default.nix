{ pkgs, ...}:

pkgs.python27.pkgs.buildPythonPackage rec {
  version  = "2.0.3";
  baseName = "pync";
  name     = "${baseName}-${version}";
  disabled = ! pkgs.stdenv.isDarwin;

  src = pkgs.fetchurl {
    url = "mirror://pypi/p/${baseName}/${name}.tar.gz";
    sha256 = "0zqim86gzlg80gx7fzzzyimg7656brgkqxx52691y5m36lbydf9q";
  };

  buildInputs = [ pkgs.coreutils pkgs.terminal-notifier ];

  propagatedBuildInputs = [ pkgs.python27.pkgs.dateutil ];

  patchPhase = pkgs.stdenv.lib.optionalString pkgs.stdenv.isDarwin ''
    sed -i 's|/usr/local/bin/|${pkgs.terminal-notifier}/bin/|g' pync/TerminalNotifier.py
  '';

  meta = {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage    = https://pypi.python.org/pypi/pync/1.4;
  };
}