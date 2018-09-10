{ stdenv, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15g77mvkaw6si9f7pmb1a9sx04wh0fsscmj0apk2qhcs5wivkki0";
  };

  doCheck = false;

  propagatedBuildInputs = [
    requests six
  ];

  meta = with stdenv.lib; {
    description = "Python wrapper for the GitLab API ";
    homepage = https://github.com/python-gitlab/python-gitlab;
  };
}