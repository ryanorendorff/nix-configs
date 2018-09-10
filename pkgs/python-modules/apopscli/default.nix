{ fetchpypi ? myPythonPackages.fetchpypi, beautifulsoup4, boto3, buildPythonPackage, cement, consul, cookiecutter, python-jenkins, python-gitlab ? myPythonPackages.python-gitlab, pyyaml, requests, semver, sh, stdenv, yamlordereddictloader ? myPythonPackages.yamlordereddictloader, myPythonPackages }:

let
  mkOverride = pkg: version: sha256: pkg.overridePythonAttrs(oldAttrs: {
    inherit version;
    src = oldAttrs.src.override {
      inherit version sha256;
    };
  });
  mkZgOverride = pkg: version: sha256: (mkOverride pkg version sha256).overridePythonAttrs(oldAttrs: {
    src = fetchpypi (with { pname = oldAttrs.pname; }; {
      inherit pname version sha256;
      pypiIndex = "https://pypi.stage.ap.truaws.com";
    });
  });
  defaultOverrides = [
    (mkOverride beautifulsoup4 "4.6.0"       "12cf0ygpz9srpfh9gx2f9ba0swa1rzypv3sm4r0hmjyw6b4nm2w0")
    (mkOverride cement         "2.10.2"      "d50c5980bf3e2456e515178ba097d16e36be0fbcab7811a60589d22f45b64f55")
    (mkOverride consul         "0.7.2"       "0wb578i83brjsx764ifj26jj4ph3wpdsli9gc3wsbywf5n57q2zg")
    (mkOverride python-gitlab  "1.5.1"       "13a4yvglkks64vkzana39gvjmv5s5q5qgrgjfl9z51hjsn9f2zl0")
    (mkZgOverride cookiecutter "1.4.0+zfork" "b8cc8026e616854f59c164019c83e945a34f41976073b838e3645bee5748a574" )
  ];
in
buildPythonPackage rec {
  pname = "apopscli";
  version = "0.10.5";

  src = fetchpypi {
    inherit pname version;
    pypiIndex = "https://pypi.stage.ap.truaws.com";
    sha256 = "93b21cb4d4c41ebca9d31e82b25bfa64513ea37f078c2d9e8ec14f81b812f0b6";
  };

  doCheck = false;

  propagatedBuildInputs = [
    boto3
    python-jenkins
    pyyaml
    requests
    semver
    sh
    yamlordereddictloader
  ] ++ defaultOverrides;

  meta = with stdenv.lib; {
    description = "Aims to automate various processes around apops";
    homepage = https://stash.sv2.trulia.com/projects/AFRA/repos/apops-cli;
  };
}