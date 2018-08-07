{ pkgs, ...}:

with {
  myPackages = pkgs.mine.python27Packages;
  pythonPackages = pkgs.python27Packages;
};
pythonPackages.buildPythonPackage rec {
  pname = "apopscli";
  version = "0.8.1";

  src = myPackages.fetchpypi {
    inherit pname version;
    pypiIndex = "https://pypi.stage.ap.truaws.com";
    sha256 = "44d8f272a30cae1cebd6b29fab2b64b4e078c5fdc357c56281c67348c499e7d7";
  };

  doCheck = false;

  propagatedBuildInputs = [
    myPackages.consul
    myPackages.yamlordereddictloader
    myPackages.zcookiecutter
    pythonPackages.beautifulsoup4
    pythonPackages.boto3
    pythonPackages.python-jenkins
    pythonPackages.cement
    pythonPackages.sh
    pythonPackages.semver
  ];

  meta = with stdenv.lib; {
    description = "Aims to automate various processes around apops";
    homepage = https://stash.sv2.trulia.com/projects/AFRA/repos/apops-cli;
  };
}