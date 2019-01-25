{ pkgs, pythonPackages, myPythonPackages, ... }:

with pkgs; with pythonPackages;
rec {
  # apopscli = callPackage ./apopscli {
  #   inherit myPythonPackages;
  #   ndg-httpsclient = myPythonPackages.ndg-httpsclient;
  #   boto3 = myPythonPackages.boto3;
  #   pyasn1 = myPythonPackages.pyasn1;
  # };

  aws-encryption-sdk = callPackage ./aws-encryption-sdk { };

  boto3 = callPackage ./boto3 {
    inherit (myPythonPackages);
    botocore = myPythonPackages.botocore;
  };

  botocore = callPackage ./botocore { };

  cement = callPackage ./cement { };

  diskcache = callPackage ./diskcache { };

  fetchpypi = callPackage ./fetchpypi { };

  ndg-httpsclient = callPackage ./ndg-httpsclient { };

  pyasn1 = callPackage ./pyasn1 { };

  pync2 = callPackage ./pync2 { };

  python-gitlab = callPackage ./python-gitlab { };

  yamlordereddictloader = callPackage ./yamlordereddictloader { };
}
