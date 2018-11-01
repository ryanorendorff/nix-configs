{ fetchPypi
, botocore
, urllib3
}:

botocore.overridePythonAttrs(oldAttrs: rec {
  version = "1.12.30";
  src = oldAttrs.src.override {
    version = "1.12.30";
    sha256 = "1xl3mqk2v79868qvsdjy73zdpg551c6n9cxy3q37jx33jvq104jy";
  };
  propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
    urllib3
  ];
})