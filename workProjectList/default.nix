{
  gitlab = {
    apex = [
      { repo = "agent-teams"; shell = ../shells/php55/default.nix; build = false; }
    ];
    apops = [
      { repo = "apops-cli"; }
      { repo = "apops"; shell = ../shells/zg-apops; build = false; }
    ];
    closers = [
      { repo = "agent-platform-core-clients"; }
      { repo = "aps-contacts"; }
      { repo = "crm-data-entities"; }
      { repo = "contact-proxy-webserver"; }
      { repo = "crm-data-repository"; shell = ../shells/php55/default.nix; build = false; }
    ];
    delta-force = [
      { repo = "agent-phone-provisioning-service"; shell = ../shells/zg-agent-phone-provisioning-service/default.nix; build = false; }
      { repo = "capi-server"; }
      { repo = "ean-client"; }
      { repo = "ean-data-repository"; }
      { repo = "goodcop"; shell = ../shells/zg-goodcop/default.nix; build = false; }
      { repo = "jumpball-callback-service"; shell = ../shells/php71/default.nix; }
      { repo = "l2-functional-tests"; }
      { repo = "l2-queue-essentials"; }
      { repo = "lead-model-serialization"; }
      { repo = "lead-model"; }
      { repo = "leadrouting-handler"; shell = ../shells/zg-leadrouting-handler/default.nix; build = false; }
      { repo = "wiggum"; }
    ];
    rouge = [
      { repo = "zillow-readiness-handler"; }
    ];
    tab = [
      { repo = "tab"; build = false; }
    ];
    tdoggett = [
      { repo = "gitlab-runner-testing"; }
      { repo = "innovation_week_voter_client"; }
    ];
    ux = [
      { repo = "paxl-react"; build = false; }
    ];
    yoltron = [
      { repo = "agent-platform-tools-endpoints"; }
      { repo = "agent-platform-tools"; shell = ../shells/node/default.nix; }
      { repo = "api-service-messaging"; shell = ../shells/php71; }
      { repo = "aps-messages"; shell = ../shells/zg-aps-messages/default.nix; build = false; }
      { repo = "aps-push-notification"; }
      { repo = "crm-messages"; }
      { repo = "crm-webhookz"; }
      { repo = "dispatcher"; shell = ../shells/zg-dispatcher/default.nix; }
      { repo = "dispatcher-model"; shell = ../shells/zg-dispatcher-model/default.nix; build = false; }
      { repo = "gmail-webservices"; }
      { repo = "home-recommendations-service"; shell = ../shells/php71/default.nix; build = false; }
      { repo = "lead-notifications-lambda"; shell = ../shells/node/default.nix; }
      { repo = "kinesis-lead-event-to-sqs-lambda"; shell = ../shells/node/default.nix; }
      { repo = "sqs-lead-event-to-dispatcher-lambda"; shell = ../shells/node/default.nix; }
      { repo = "video-message-template-provisioner"; }
      { repo = "video-message-template-service"; }
      { repo = "web-crm-frontend"; shell = ../shells/zg-web-crm-frontend/default.nix; build = false; }
      { repo = "web-crm"; }
    ];
  };
  stash = {
    aps = [
      { repo = "api-authentication-handler"; }
      { repo = "api-json-schema-provider"; }
      { repo = "aps-client"; }
      { repo = "aps-util"; }
      { repo = "event-payload-injector"; }
      { repo = "message-client"; }
    ];
    zrm = [
      { repo = "agenthub-api-client"; build = false; }
      { repo = "autoresponder-service"; build = false; }
      { repo = "hybrid-thread-orchestration"; build = false; }
      { repo = "leadrouting-data-repository"; }
      { repo = "leadrouting-lib"; }
      { repo = "nav-bundle"; }
      { repo = "paxl-react"; shell = ../shells/node/default.nix; build = false; }
      { repo = "paxl"; }
      { repo = "polaris-bethid-api"; }
      { repo = "thread-data-repository"; shell = ../shells/php55/default.nix; build = false; }
      { repo = "trulia-featured-listings-api-client"; }
      { repo = "url-signer"; }
    ];
  };
}
