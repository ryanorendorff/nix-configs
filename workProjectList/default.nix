{
  gitlab = {
    apops = [
      { repo = "apops-cli"; }
    ];
  };
  stash = {
    afra = [
      { repo = "apops"; shell = ../shells/zg-apops; }
    ];
    aps = [
      { repo = "api-authentication-handler"; }
      { repo = "api-json-schema-provider"; }
      { repo = "aps-client"; }
      { repo = "aps-contacts"; }
      { repo = "aps-messages"; shell = ../shells/zg-aps-messages/default.nix; }
      { repo = "aps-push-notification"; }
      { repo = "aps-team-stats"; }
      { repo = "aps-util"; }
      { repo = "event-payload-injector"; }
      { repo = "house-on-fire"; }
      { repo = "message-client"; }
    ];
    chuck = [
      { repo = "dispatcher"; shell = ../shells/zg-dispatcher/default.nix; }
      { repo = "dispatcher-model"; shell = ../shells/zg-dispatcher-model/default.nix; }
    ];
    com = [
      { repo = "email"; build = false; }
    ];
    ean = [
      { repo = "agent-phone-provisioning-service"; shell = ../shells/zg-agent-phone-provisioning-service/default.nix; }
      { repo = "ean-data-repository"; }
      { repo = "wiggum"; }
    ];
    lemmy = [
      { repo = "goodcop"; shell = ../shells/zg-goodcop/default.nix; }
      { repo = "l2-functional-tests"; }
      { repo = "l2-queue-essentials"; }
      { repo = "lead-model"; }
      { repo = "lead-model-serialization"; }
    ];
    npm = [
      { repo = "navbar"; shell = ../shells/trulia-navbar/default.nix; build = false; }
    ];
    sup = [
      { repo = "account-migration"; }
      { repo = "agent-directory-scripts"; }
      { repo = "user-profile-api-client"; }
      { repo = "user-profile-service"; }
    ];
    tem = [
      { repo = "react-app-template"; shell = ../shells/zg-react-app-template/default.nix; }
    ];
    web = [ # We don't build anything in web because they take too long and we rarely use them
      { repo = "agentprofile"; build = false; }
      { repo = "agentweb"; build = false; }
      { repo = "code-quality-configs"; }
      { repo = "common"; build = false; }
      { repo = "salesforce"; build = false; }
      { repo = "web"; build = false; }
    ];
    zrm = [
      { repo = "agent-platform-core-clients"; }
      { repo = "agent-platform-tools-endpoints"; }
      { repo = "agent-platform-tools"; shell = ../shells/node/default.nix; }
      { repo = "agent-teams-utilities"; }
      { repo = "agent-teams"; shell = ../shells/php55/default.nix; build = false; }
      { repo = "agenthub-api-client"; }
      { repo = "agentteamsproc"; }
      { repo = "autoresponder-service"; }
      { repo = "capi-server"; }
      { repo = "crm-data-entities"; }
      { repo = "crm-data-repository"; shell = ../shells/php55/default.nix; }
      { repo = "ean-client"; }
      { repo = "hybrid-thread-orchestration"; }
      { repo = "home-recommendations-service"; shell = ../shells/php71/default.nix; }
      { repo = "lead-forwarding-proc"; }
      { repo = "lead-routing-api"; }
      { repo = "leadrouting-data-repository"; }
      { repo = "leadrouting-handler"; shell = ../shells/zg-leadrouting-handler/default.nix; }
      { repo = "leadrouting-lib"; }
      { repo = "nav-bundle"; }
      { repo = "notifications-panel"; shell = ../shells/node/default.nix; }
      { repo = "paxl-react-pageheader"; shell = ../shells/node/default.nix; }
      { repo = "paxl-react"; shell = ../shells/node/default.nix; }
      { repo = "paxl"; }
      { repo = "polaris-bethid-api"; }
      { repo = "polaris-lead-events-proc"; }
      { repo = "polaris-to-beth-concierge-proc"; }
      { repo = "puppetmaster"; shell = ../shells/node/default.nix; }
      { repo = "styleguide"; shell = ../shells/node/default.nix; }
      { repo = "thread-data-repository"; shell = ../shells/php55/default.nix; }
      { repo = "trulia-featured-listings-api-client"; }
      { repo = "trulia-featured-listings-api"; }
      { repo = "universal-nav-ui"; }
      { repo = "url-signer"; }
      { repo = "video-message-template-provisioner"; }
      { repo = "video-message-template-service"; }
      { repo = "web-crm-frontend"; }
      { repo = "web-crm"; }
      { repo = "zillow-readiness-handler"; }
    ];
    "~tdoggett" = [
      { repo = "innovation_week_voter_client"; }
    ];
  };
}