let
  accessKeyId = "nixops"; # symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
  region = "us-west-1";
in {
  exploring-blog-server = { resources, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = accessKeyId;
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t3.nano";
    deployment.ec2.keyPair = resources.ec2KeyPairs.kens-key-pair;
    deployment.ec2.associatePublicIpAddress = true;
    deployment.ec2.elasticIPv4 = resources.elasticIPs.exploring-blog-server-ip;
    deployment.ec2.securityGroups = with resources.ec2SecurityGroups; [ ssh-sec http-sec ];
  };

  resources.ec2KeyPairs.kens-key-pair = { inherit region accessKeyId; };
  resources.elasticIPs.exploring-blog-server-ip = { inherit region accessKeyId; vpc = true; };

  resources.ec2SecurityGroups.ssh-sec = {
    inherit region accessKeyId;
    name = "kens-network-ssh-sec";
    description = "kens-network-ssh-sec";
    rules = [
      { fromPort = 22;   toPort = 22;   sourceIp = "0.0.0.0/0"; }
    ];
  };
  resources.ec2SecurityGroups.http-sec = {
    inherit region accessKeyId;
    name = "kens-network-http-sec";
    description = "kens-network-http-sec";
    rules = [
      { fromPort = 80;   toPort = 80;   sourceIp = "0.0.0.0/0"; }
      { fromPort = 443;  toPort = 443;  sourceIp = "0.0.0.0/0"; }
    ];
  };
}
