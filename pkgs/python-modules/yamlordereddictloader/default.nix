{ stdenv, buildPythonPackage, pythonPackages, fetchPypi, pyyaml }: 

buildPythonPackage rec {
  pname = "yamlordereddictloader";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03h8wa6pzqjiw25s3jv9gydn77gs444mf31lrgvpgy53kswz0c3z";
  };

  buildInputs = [ pyyaml ];

  propogatedBuildInputs = [ pyyaml ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "This module provide a loader and a dumper for PyYAML.";
    homepage = https://github.com/fmenabe/python-yamlordereddictloader;
  };
}