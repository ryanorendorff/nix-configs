{
  fetchpypi ? myPythonPackages.fetchpypi,
  aws-encryption-sdk ? myPythonPackages.aws-encryption-sdk,
  beautifulsoup4,
  boto3 ? myPythonPackages.boto3,
  buildPythonPackage,
  consul,
  cookiecutter,
  diskcache ? myPythonPackages.diskcache,
  ndg-httpsclient ? myPythonPackages.ndg-httpsclient,
  pyasn1 ? myPythonPackages.pyasn1,
  pyopenssl,
  python-jenkins,
  python-gitlab ? myPythonPackages.python-gitlab, 
  pyyaml,
  requests,
  semver,
  setuptools,
  sh,
  stdenv,
  yamlordereddictloader ? myPythonPackages.yamlordereddictloader,
  myPythonPackages
}:

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
    disabled = false;
  });
  overrides = {
    aws-encryption-sdk = (mkOverride aws-encryption-sdk  "1.3.7"       "10yk23nqpxnawpm9zfib344i9dcg95m81nr653xcf1ghvv90g4wh");
    beautifulsoup4     = (mkOverride beautifulsoup4      "4.6.0"       "12cf0ygpz9srpfh9gx2f9ba0swa1rzypv3sm4r0hmjyw6b4nm2w0");
    boto3              = (mkOverride boto3               "1.9.10"      "02i83qi1q137v6va79515ragqf02flyhwxd2zaccn9vdl1q10055");
    cement             = myPythonPackages.python-gitlab;
    consul             = (mkOverride consul              "0.7.2"       "0wb578i83brjsx764ifj26jj4ph3wpdsli9gc3wsbywf5n57q2zg");
    cookiecutter       = (mkZgOverride cookiecutter      "1.4.0+zfork" "b8cc8026e616854f59c164019c83e945a34f41976073b838e3645bee5748a574" );
    diskcache          = (mkOverride diskcache           "3.0.6"       "1wyb4hks977i2c134dnxdsgq0wgwk1gb3d5yk3zhgjidc6f1gw0m");
    ndg-httpsclient    = (mkOverride ndg-httpsclient     "0.5.1"       "0412b7i1s4vj7lz9r72nmb28h9syd4q2x89bdirkkc3a6z8awbyp");
    pyasn1             = (mkOverride pyasn1              "0.4.4"       "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137");
    pyopenssl          = (mkOverride pyopenssl           "18.0.0"      "1055rb456nvrjcij3sqj6c6l3kmh5cqqay0nsmx3pxq07d1g3234");
    python-gitlab      = (mkOverride python-gitlab       "1.5.1"       "13a4yvglkks64vkzana39gvjmv5s5q5qgrgjfl9z51hjsn9f2zl0");
  };
in
buildPythonPackage rec {
  pname = "apopscli";
  version = "0.11.4";

  src = fetchpypi {
    inherit pname version;
    pypiIndex = "https://pypi.stage.ap.truaws.com";
    sha256 = "91aa997d620c99fd31280c58075dabeb3413ec40251ea7ca8c74580d33b207d3";
  };

  buildInputs = [
    setuptools
    overrides.pyopenssl
  ];

  doCheck = false;

  propagatedBuildInputs = [
    overrides.aws-encryption-sdk
    overrides.boto3
    overrides.beautifulsoup4
    overrides.cement
    overrides.consul
    overrides.cookiecutter
    overrides.diskcache
    overrides.ndg-httpsclient
    overrides.pyopenssl
    overrides.pyasn1
    overrides.python-gitlab
    python-jenkins
    pyyaml
    requests
    semver
    sh
    yamlordereddictloader
  ];

  meta = with stdenv.lib; {
    description = "Aims to automate various processes around apops";
    homepage = https://stash.sv2.trulia.com/projects/AFRA/repos/apops-cli;
  };
}
