{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "wtfutil-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "senorprogrammer";
    repo = "wtf";
    rev = version;
    sha256 = "085mqz4h6m0hzm1ash4a30vv3grnkw0qfw6fkkaszncps4fbmr01";
  };

  goPackagePath = "github.com/senorprogrammer/wtf";

  meta = with lib; {
    description = "A personal information dashboard for your terminal";
    license = licenses.mpl20;
    homepage = https://wtfutil.com;
  };
}

