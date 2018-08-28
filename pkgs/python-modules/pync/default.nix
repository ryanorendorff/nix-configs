{ buildPythonPackage, fetchurl, stdenv, coreutils, terminal-notifier, dateutil }: 

buildPythonPackage rec {
  version  = "2.0.3";
  baseName = "pync";
  name     = "${baseName}-${version}";
  disabled = ! stdenv.isDarwin;

  src = fetchurl {
    url = "mirror://pypi/p/${baseName}/${name}.tar.gz";
    sha256 = "0zqim86gzlg80gx7fzzzyimg7656brgkqxx52691y5m36lbydf9q";
  };

  buildInputs = [ coreutils terminal-notifier ];

  propagatedBuildInputs = [ dateutil ];

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|/usr/local/bin/|${terminal-notifier}/bin/|g' pync/TerminalNotifier.py
  '';

  meta = {
    description = "Python Wrapper for Mac OS 10.8 Notification Center";
    homepage    = https://pypi.python.org/pypi/pync/1.4;
  };
}
