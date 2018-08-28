{ pkgs, pythonPackages, myPythonPackages, ... }:

with pkgs; with pythonPackages; with myPythonPackages;
{

  apopscli = callPackage ./apopscli {
    inherit cement;
    inherit consul;
    inherit fetchpypi;
    inherit python-gitlab;
    inherit yamlordereddictloader;
    inherit zcookiecutter;
  };

  cement = callPackage ./cement { };

  consul = callPackage ./consul { };

  fetchpypi = callPackage ./fetchpypi { };

  pync = callPackage ./pync { };

  python-gitlab = callPackage ./python-gitlab { };

  pyyaml = callPackage ./pyyaml { };

  yamlordereddictloader = callPackage ./yamlordereddictloader {
    inherit pyyaml;
  };

  zcookiecutter = callPackage ./zcookiecutter { 
    inherit fetchpypi;
  };

}