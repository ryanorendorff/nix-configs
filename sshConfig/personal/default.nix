{ ... }:

[
  {
    host = "hassio.local";
    hostname = "hassio.local";
    identityFile = toString ../../keys/private/id_rsa;
    user = "root";
  }
  {
    host = "gitlab";
    hostname = "gitlab.com";
    identityFile = toString ../../keys/private/id_rsa;
    user = "git";
  }
  {
    host = "github";
    hostname = "github.com";
    identityFile = toString ../../keys/private/id_rsa;
    user = "git";
  }
  {
    host = "remote_gollum";
    hostname = "home.nocoolnametom.com";
    identityFile = toString ../../keys/private/id_rsa;
    user = "pi";
    port = 22223;
  }
  {
    host = "remote_bill";
    hostname = "home.nocoolnametom.com";
    identityFile = toString ../../keys/private/id_rsa;
    user = "pi";
    port = 22224;
  }
  {
    host = "linode";
    hostname = "nocoolnametom.com";
    identityFile = toString ../../keys/private/id_rsa;
    user = "doggetto";
    port = 2222;
  }
  {
    host = "elrond";
    hostname = "45.33.53.132";
    identityFile = toString ../../keys/private/id_rsa;
    user = "root";
    port = 2222;
  }
  {
    host = "frodo";
    hostname = "frodo";
    identityFile = toString ../../keys/private/id_rsa;
    user = "pi";
  }
  {
    host = "bill";
    hostname = "bill";
    identityFile = toString ../../keys/private/id_rsa;
    user = "pi";
  }
  {
    host = "gollum";
    hostname = "gollum";
    identityFile = toString ../../keys/private/id_rsa;
    user = "pi";
  }
]