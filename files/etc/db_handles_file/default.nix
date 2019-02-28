{ pkgs, ... }:

pkgs.writeTextFile {
  name = "db_handles.json";
  text = ''
    {
      "agent_mobile_profile": {
        "user": "root",
        "password": "",
        "credential": "",
        "database": "AgentMobileProfile",
        "host": "crm-mysql"
      },
      "agent_mobile_profile_readonly": {
        "user": "root",
        "password": "",
        "credential": "",
        "database": "AgentMobileProfile",
        "host": "crm-mysql"
      },
      "threads_readonly": {
        "user": "root",
        "password": "",
        "database": "threads",
        "host": "crm-mysql",
        "credential": ""
      },
      "threads": {
        "user": "root",
        "password": "",
        "database": "threads",
        "host": "crm-mysql",
        "credential": ""
      },
      "agent_platform": {
        "user": "root",
        "password": "",
        "database": "CRM",
        "host": "crm-mysql",
        "credential": ""
      },
      "agent_platform_readonly": {
        "user": "root",
        "password": "",
        "database": "CRM",
        "host": "crm-mysql",
        "credential": ""
      },
      "agent_platform": {
        "user": "readwrite",
        "password": "${import ../../../keys/private/ap_readwrite_db.nix}",
        "credential": "${toString (../../../keys/private/trulia_rsa)}",
        "database": "crm",
        "host": "stagedb.sv2.trulia.com"
      },
      "agent_platform_readonly": {
        "user": "readonly",
        "password": "${import ../../../keys/private/ap_readonly_db.nix}",
        "credential": "${toString (../../../keys/private/trulia_rsa)}",
        "database": "crm",
        "host": "stagedb.sv2.trulia.com"
      }
    }
  '';
}
