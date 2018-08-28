{ stdenv, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "python-consul";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wb578i83brjsx764ifj26jj4ph3wpdsli9gc3wsbywf5n57q2zg";
  };

  buildInputs = [
    requests
    six
  ];

  propogatedBuildInputs = [
    requests
    six
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python client for Consul";
    homepage = https://github.com/fmenabe/python-yamlordereddictloader;
  };
}