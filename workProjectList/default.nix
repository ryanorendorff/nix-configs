{
  afra = [
    { repo = "apops"; }
  ];
  aps = [
    { repo = "api-authentication-handler"; }
    { repo = "api-json-schema-provider"; }
    { repo = "aps-client"; }
    { repo = "aps-contacts"; }
    { repo = "aps-messages"; shell = ../shells/php55/default.nix; build = false; }
    { repo = "aps-push-notification"; }
    { repo = "aps-team-stats"; }
    { repo = "aps-util"; }
    { repo = "event-payload-injector"; }
    { repo = "house-on-fire"; }
    { repo = "message-client"; }
  ];
  chuck = [
    { repo = "dispatcher"; shell = ../shells/dispatcher/default.nix; }
    { repo = "dispatcher-model"; shell = ../shells/php55/default.nix; build = false; }
  ];
  com = [
    { repo = "email"; build = false; }
  ];
  ean = [
    { repo = "agent-phone-provisioning-service"; }
    { repo = "wiggum"; }
  ];
  lemmy = [
    { repo = "goodcop"; }
    { repo = "l2-functional-tests"; }
    { repo = "lead-model"; }
    { repo = "lead-model-serialization"; }
  ];
  npm = [
    { repo = "navbar"; build = false;}
  ];
  sup = [
    { repo = "account-migration"; }
    { repo = "agent-directory-scripts"; }
    { repo = "user-profile-api-client"; }
    { repo = "user-profile-service"; }
  ];
  tem = [
    { repo = "react-app-template"; }
  ];
  web = [
    { repo = "agentprofile"; build = false; }
    { repo = "agentweb"; build = false; }
    { repo = "code-quality-configs"; }
    { repo = "common"; build = false; }
    { repo = "salesforce"; build = false; }
    { repo = "web"; build = false; }
  ];
  zrm = [
    { repo = "agent-platform-core-clients"; }
    { repo = "agent-teams-utilities"; }
    { repo = "agent-teams"; shell = ../shells/php55/default.nix; build = false; }
    { repo = "agenthub-api-client"; }
    { repo = "agentteamsproc"; }
    { repo = "autoresponder-service"; }
    { repo = "capi-server"; }
    { repo = "crm-data-entities"; }
    { repo = "crm-data-repository"; }
    { repo = "ean-client"; }
    { repo = "hybrid-thread-orchestration"; }
    { repo = "lead-forwarding-proc"; }
    { repo = "lead-routing-api"; }
    { repo = "leadrouting-data-repository"; }
    { repo = "leadrouting-handler"; shell = ../shells/leadrouting-handler/default.nix; build = false; }
    { repo = "leadrouting-lib"; }
    { repo = "nav-bundle"; }
    { repo = "notifications-panel"; }
    { repo = "paxl-react-pageheader"; }
    { repo = "paxl-react"; }
    { repo = "paxl"; }
    { repo = "polaris-bethid-api"; }
    { repo = "polaris-lead-events-proc"; }
    { repo = "polaris-to-beth-concierge-proc"; }
    { repo = "puppetmaster"; }
    { repo = "styleguide"; }
    { repo = "thread-data-repository"; }
    { repo = "trulia-featured-listings-api-client"; }
    { repo = "trulia-featured-listings-api"; }
    { repo = "video-message-template-provisioner"; }
    { repo = "video-message-template-service"; }
    { repo = "web-crm-frontend"; }
    { repo = "web-crm"; }
    { repo = "zillow-readiness-handler"; }
  ];
  "~tdoggett" = [
    { repo = "innovation_week_voter_client"; }
  ];
}
