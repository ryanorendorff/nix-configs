{ pkgs, ...}:

with pkgs; with python27Packages; with { myPackages = mine.python27Packages; };

buildPythonPackage rec {
  pname = "apopscli";
  version = "0.8.1";

  src = myPackages.fetchpypi {
    inherit pname version;
    pypiIndex = "https://pypi.stage.ap.truaws.com";
    sha256 = "44d8f272a30cae1cebd6b29fab2b64b4e078c5fdc357c56281c67348c499e7d7";
  };

  doCheck = false;

  propagatedBuildInputs = [
    myPackages.yamlordereddictloader
    myPackages.zcookiecutter
    beautifulsoup4
    boto3
    python-jenkins
    consul
    cement
    sh
    semver
  ];

  meta = with stdenv.lib; {
    description = "Aims to automate various processes around apops";
    homepage = https://stash.sv2.trulia.com/projects/AFRA/repos/apops-cli;
  };
}