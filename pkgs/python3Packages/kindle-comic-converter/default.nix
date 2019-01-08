{ pkgs ? (import <nixpkgs> {}), ...}:

pkgs.python3Packages.buildPythonApplication rec {
  name = "kindle-comic-converter";
  pname = "KindleComicConverter";
  version = "5.4.5";

  src = pkgs.fetchFromGitHub {
    owner = "ciromattia";
    repo = "kcc";
    rev = version;
    sha256 = "1qn77vfk7146rxzlmvg4vx0p70x85zkb6y5axp0bbd9gvgl4wpha";
  };

  disabled = pkgs.python3Packages.pythonOlder "3.5.0";

  doCheck = false;

  postPatch = ''
    # For some reason there's an error with PyQt5 not being detected by setuptools. So… hack.
    sed -ibak "/'PyQt5>=5.6.0',/d" setup.py && rm setup.pybak
  '';

  propagatedBuildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [
      pyqt5
      python-slugify
      pillow
      psutil
      raven
    ]))
    pkgs.kindlegen
    pkgs.p7zip
    pkgs.unrar
  ];

  meta = with pkgs.stdenv.lib; {
    description = "Python wrapper for the GitLab API ";
    homepage = https://github.com/python-gitlab/python-gitlab;
  };
}