{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cement";
  version = "2.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0magnr2jzll90nk12y5bph7vwdkfs6bs12qp2pjmc91ypy05j36m";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://builtoncement.com/;
    description = "A CLI Application Framework for Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.bsd3;
  };
}