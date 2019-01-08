{ pkgs, pythonPackages, myPythonPackages, ...}:

with pkgs; with pythonPackages; with myPythonPackages;

stdenv.mkDerivation rec {
  version = "1.0-alpha1";
  name = "i3-gnome-pomodoro-${version}";

  src = fetchFromGitHub {
    owner = "kantord";
    repo = "i3-gnome-pomodoro";
    rev = "7e654f695c92f04b840720b9fd13ea1c874bcafa";
    sha256 = "08100lfli2qxjsl3gsjx6q35488sbisb1xszarxvi0r1dd5v1px3";
  };

  unpackPhase = "true";

  buildInputs = [
    makeWrapper
    python
    pydbus
    click
    i3ipc
    gnome3.pomodoro
  ];

  propagatedBuildInputs = [
    python
    pydbus
    click
    i3ipc
    gnome3.pomodoro
  ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/pomodoro-client.py $out/bin/pomodoro-client
    wrapProgram $out/bin/pomodoro-client --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kantord/i3-gnome-pomodoro;
    description = "Integrate gnome-pomodoro into i3";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nocoolnametom ];
  };
}