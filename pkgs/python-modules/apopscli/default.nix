{ stdenv, buildPythonPackage, fetchpypi, consul, yamlordereddictloader, zcookiecutter, python-gitlab, beautifulsoup4, boto3, python-jenkins, cement, requests, sh, semver }:

buildPythonPackage rec {
  pname = "apopscli";
  version = "0.10.0";

  src = fetchpypi {
    inherit pname version;
    pypiIndex = "https://pypi.stage.ap.truaws.com";
    sha256 = "97770deec386f6872133351c1ac0bfc730745f05873f847c619fcbb7e791e87b";
  };

  doCheck = false;

  propagatedBuildInputs = [
    consul
    yamlordereddictloader
    zcookiecutter
    python-gitlab
    beautifulsoup4
    boto3
    python-jenkins
    cement
    requests
    sh
    semver
  ];

  meta = with stdenv.lib; {
    description = "Aims to automate various processes around apops";
    homepage = https://stash.sv2.trulia.com/projects/AFRA/repos/apops-cli;
  };
}