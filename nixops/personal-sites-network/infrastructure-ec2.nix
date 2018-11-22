let
  accessKeyId = "nixops"; # symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
  region = "us-west-1";
in {
  professional-page-server = { resources, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = accessKeyId;
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t3.nano";
    deployment.ec2.keyPair = resources.ec2KeyPairs.my-key-pair;
    deployment.ec2.associatePublicIpAddress = true;
    deployment.ec2.elasticIPv4 = resources.elasticIPs.professional-page-server-ip;
    deployment.ec2.securityGroups = [ "allow-ssh" "allow-http" ];
  };

  resources.ec2KeyPairs.my-key-pair = { inherit region accessKeyId; };
  resources.elasticIPs.professional-page-server-ip = { inherit region accessKeyId; vpc = true; };
}
