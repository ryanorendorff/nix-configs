{ lib
, fetchPypi
, boto3
, botocore
, jmespath
, s3transfer
, futures
, isPy3k
}:

let s3transferOverride = s3transfer.overridePythonAttrs(oldAttrs: rec {
  propagatedBuildInputs = [ botocore ] ++ lib.optionals (!isPy3k) [ futures ];
});
in boto3.overridePythonAttrs(oldAttrs: rec {
  version = "1.9.10";
  src = fetchPypi {
    pname = "boto3";
    version = "1.9.10";
    sha256 = "02i83qi1q137v6va79515ragqf02flyhwxd2zaccn9vdl1q10055";
  };
  buildInputs = [ botocore ];
  propagatedBuildInputs = [ botocore jmespath s3transferOverride ] ++ lib.optionals (!isPy3k) [ futures ];
})
