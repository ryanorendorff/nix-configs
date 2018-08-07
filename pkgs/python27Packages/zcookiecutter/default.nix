{ pkgs, ... }:

with pkgs; with python27Packages; with { myPackages = mine.python27Packages; };

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "1.4.0+zfork";

  # not sure why this is broken
  disabled = isPyPy;

  src = myPackages.fetchpypi {
    inherit pname version;
    pypiIndex = "https://pypi.stage.ap.truaws.com";
    sha256 = "b8cc8026e616854f59c164019c83e945a34f41976073b838e3645bee5748a574";
  };

  checkInputs = [ pytest pytestcov pytest-mock freezegun ];
  propagatedBuildInputs = [
    jinja2 future binaryornot click whichcraft poyo jinja2_time requests
  ];
  
  # requires network access for cloning git repos
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/audreyr/cookiecutter;
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}