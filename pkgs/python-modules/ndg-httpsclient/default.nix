{ stdenv, buildPythonPackage, fetchPypi, pyasn1, pyopenssl }:

buildPythonPackage rec {
  pname = "ndg_httpsclient";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0412b7i1s4vj7lz9r72nmb28h9syd4q2x89bdirkkc3a6z8awbyp";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pyasn1
    pyopenssl
  ];

  meta = with stdenv.lib; {
    description = "HTTPS client implementation for httplib and urllib2 based on PyOpenSSL ";
    homepage = https://github.com/cedadev/ndg_httpsclient/;
  };
}