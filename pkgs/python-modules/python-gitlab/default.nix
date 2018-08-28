{ stdenv, buildPythonPackage, fetchPypi, requests, six }:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13a4yvglkks64vkzana39gvjmv5s5q5qgrgjfl9z51hjsn9f2zl0";
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