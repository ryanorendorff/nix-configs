{ stdenv, buildPythonPackage, fetchPypi, boto3, cryptography, attrs, wrapt }:

buildPythonPackage rec {
  pname = "aws-encryption-sdk";
  version = "1.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10yk23nqpxnawpm9zfib344i9dcg95m81nr653xcf1ghvv90g4wh";
  };

  doCheck = false;

  propagatedBuildInputs = [
    boto3 cryptography attrs wrapt
  ];

  meta = with stdenv.lib; {
    description = "Python wrapper for the AWS Encryption SDK";
    homepage = https://docs.aws.amazon.com/encryption-sdk/latest/developer-guide/introduction.html;
  };
}