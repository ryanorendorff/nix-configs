{ buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aqjl8dk9amd4zr99n8v2qxzgmr2hdvqfma4zh7a41rj6336c9sr";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A YAML parser and emitter for Python";
    homepage = http://pyyaml.org/wiki/PyYAML;
  };
}