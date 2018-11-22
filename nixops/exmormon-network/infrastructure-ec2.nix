let
  accessKeyId = "nixops"; # symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
  region = "us-west-1";
in {
  combined-server = { resources, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = accessKeyId;
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t3.micro";
    deployment.ec2.keyPair = resources.ec2KeyPairs.combined-pair;
    deployment.ec2.associatePublicIpAddress = true;
    deployment.ec2.elasticIPv4 = resources.elasticIPs.combined-server-ip;
    deployment.ec2.securityGroups = [ "allow-ssh" "allow-http" ];
  };

  resources.ec2KeyPairs.combined-pair = { inherit region accessKeyId; };
  resources.elasticIPs.combined-server-ip = { inherit region accessKeyId; vpc = true; };
}
