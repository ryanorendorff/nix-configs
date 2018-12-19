{ lib, fetchurl, stdenv, terminal-notifier, pync }:

with {
  version = "2.0.3";
  sha256 = "0zqim86gzlg80gx7fzzzyimg7656brgkqxx52691y5m36lbydf9q";
};
pync.overridePythonAttrs(oldAttrs: {
  inherit version;
  src = fetchurl {
    inherit sha256;
    url = "mirror://pypi/p/${oldAttrs.pname}/${oldAttrs.pname}-${version}.tar.gz";
  };
  preInstall = false;
  buildInputs = oldAttrs.buildInputs ++ lib.optionals stdenv.isDarwin [
    terminal-notifier
  ];
  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|/usr/local/bin/|${terminal-notifier}/bin/|g' pync/TerminalNotifier.py
  '';
})
