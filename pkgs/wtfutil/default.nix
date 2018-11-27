{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "wtfutil-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "senorprogrammer";
    repo = "wtf";
    rev = version;
    sha256 = "1vgjqmw27baiq9brmnafic3w3hw11p5qc6ahbdxi5n5n4bx7j6vn";
  };

  goPackagePath = "github.com/senorprogrammer/wtf";

  meta = with lib; {
    description = "A personal information dashboard for your terminal";
    license = licenses.mpl20;
    homepage = https://wtfutil.com;
  };
}

