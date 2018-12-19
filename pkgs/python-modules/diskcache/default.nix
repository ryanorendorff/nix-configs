{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "diskcache";
  version = "3.1.1 ";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wyb4hks977i2c134dnxdsgq0wgwk1gb3d5yk3zhgjidc6f1gw1m";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.grantjenks.com/docs/diskcache/;
    description = "An Apache2 licensed disk and file backed cache library, written in pure-Python, and compatible with Django.";
    license = licenses.apache2;
  };
}