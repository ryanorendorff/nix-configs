let
  accessKeyId = "nixops"; # symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
  region = "us-west-1";
in {
  professional-page-server = { resources, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = accessKeyId;
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t3.nano";
    deployment.ec2.keyPair = resources.ec2KeyPairs.personal-sites-key-pair;
    deployment.ec2.associatePublicIpAddress = true;
    deployment.ec2.elasticIPv4 = resources.elasticIPs.professional-page-server-ip;
    deployment.ec2.securityGroups = with resources.ec2SecurityGroups; [ ssh-sec http-sec ];
  };

  znc-server = { resources, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = accessKeyId;
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t3.nano";
    deployment.ec2.keyPair = resources.ec2KeyPairs.personal-sites-key-pair;
    deployment.ec2.associatePublicIpAddress = true;
    deployment.ec2.elasticIPv4 = resources.elasticIPs.znc-server-ip;
    deployment.ec2.securityGroups = with resources.ec2SecurityGroups; [ ssh-sec http-sec znc-sec ];
  };

  resources.ec2KeyPairs.personal-sites-key-pair = { inherit region accessKeyId; };
  resources.elasticIPs.professional-page-server-ip = { inherit region accessKeyId; vpc = true; };
  resources.elasticIPs.znc-server-ip = { inherit region accessKeyId; vpc = true; };

  resources.ec2SecurityGroups.ssh-sec = {
    inherit region accessKeyId;
    name = "personal-sites-network-ssh-sec";
    description = "personal-sites-network-ssh-sec";
    rules = [
      { fromPort = 22;   toPort = 22;   sourceIp = "0.0.0.0/0"; }
    ];
  };
  resources.ec2SecurityGroups.http-sec = {
    inherit region accessKeyId;
    name = "personal-sites-network-http-sec";
    description = "personal-sites-network-http-sec";
    rules = [
      { fromPort = 80;   toPort = 80;   sourceIp = "0.0.0.0/0"; }
      { fromPort = 443;  toPort = 443;  sourceIp = "0.0.0.0/0"; }
    ];
  };
  resources.ec2SecurityGroups.znc-sec = {
    inherit region accessKeyId;
    name = "personal-sites-network-znc-sec";
    description = "personal-sites-network-znc-sec";
    rules = [
      { fromPort = 5000; toPort = 5000; sourceIp = "0.0.0.0/0"; }
    ];
  };
}
