{ pkgs, pythonPackages, myPythonPackages, ... }:

with pkgs; with pythonPackages;
rec {
  apopscli = callPackage ./apopscli {
    inherit myPythonPackages;
  };

  fetchpypi = callPackage ./fetchpypi { };

  pync2 = callPackage ./pync2 { };

  python-gitlab = callPackage ./python-gitlab { };

  yamlordereddictloader = callPackage ./yamlordereddictloader { };
}