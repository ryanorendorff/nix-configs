{ pkgs, pythonPackages, myPythonPackages, ... }:

with pkgs; with pythonPackages; with myPythonPackages;
{

  apopscli = callPackage ./python-modules/apopscli {
    inherit consul;
    inherit cement;
    inherit fetchpypi;
    inherit yamlordereddictloader;
    inherit zcookiecutter;
    inherit python-gitlab;
  };

  cement = callPackage ./python-modules/cement { };

  consul = callPackage ./python-modules/consul { };

  fetchpypi = callPackage ./python-modules/fetchpypi { };

  pync = callPackage ./python-modules/pync { };

  python-gitlab = callPackage ./python-modules/python-gitlab { };

  pyyaml = callPackage ./python-modules/pyyaml { };

  yamlordereddictloader = callPackage ./python-modules/yamlordereddictloader {
    inherit pyyaml;
  };

  zcookiecutter = callPackage ./python-modules/zcookiecutter { 
    inherit fetchpypi;
  };

}