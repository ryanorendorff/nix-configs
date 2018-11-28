{ prefix ? "", ... }:

{ hostName ? "", extraHosts ? "" }:

{
  "${prefix}hosts" = {
    text = ''
      127.0.0.1       localhost
      255.255.255.255 broadcasthost
      ::1             localhost
      fe80::1%lo0	    localhost

      ${extraHosts}
    '';
  };
}
