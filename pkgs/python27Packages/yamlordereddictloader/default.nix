{ pkgs, ...}:

with pkgs; with python27Packages; with { myPackages = mine.python27Packages; };

buildPythonPackage rec {
  pname = "yamlordereddictloader";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vb59v76i4mgcmrx6f2jskax6q5h5s5j4g7grhxfhv6mq2vd3w5l";
  };

  buildInputs = [
    myPackages.pyyaml
  ];

  propogatedBuildInputs = [
    myPackages.pyyaml
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "This module provide a loader and a dumper for PyYAML";
    homepage = https://github.com/fmenabe/python-yamlordereddictloader;
  };
}