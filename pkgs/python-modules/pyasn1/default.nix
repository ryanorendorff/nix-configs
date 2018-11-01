{ pyasn1 }:

pyasn1.overridePythonAttrs(oldAttrs: rec {
  version = "0.4.4";
  src = oldAttrs.src.override {
    version = "0.4.4";
    sha256 = "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137";
  };
})