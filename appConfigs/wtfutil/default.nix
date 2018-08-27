{ pkgs, stdenv ? pkgs.stdenv, ...}:

pkgs.writeText "config.yml" ''
  wtf:
    grid:
      # How _wide_ the columns are, in terminal characters.
      columns: [42, 42, 42, 42, 42]

      # How _high_ the rows are, in terminal lines.
      rows: [10, 10, 10, 18]
    refreshInterval: 1
    mods:
      gcal:
        colors:
          title: "red"
          description: "lightblue"
          highlights:
          - ['1on1|1\/11', 'green']
          - ['apple|google|aws', 'blue']
          - ['interview|meet\ ', 'lightseagreen']
          - ['lunch', 'yellow']
          past: "gray"
        conflictIcon: "🚨"
        currentIcon: "💥"
        displayResponseStatus: true
        email: "nocoolnametom@gmail.com"
        enabled: true
        eventCount: 12
        multiCalendar: true
        position:
          top: 0
          left: 0
          height: 3
          width: 2
        refreshInterval: 300
        secretFile: "${../../keys/private/credentials.json}"
        withLocation: true
      todoist:
        apiKey: "${import ../../keys/private/todoist_key.nix}"
        enabled: true
        position:
          top: 2
          left: 3
          height: 2
          width: 2
        projects:
          - 135663827
        refreshInterval: 3600
      git:
        commitCount: 5
        enabled: true
        position:
          top: 0
          left: 2
          height: 2
          width: 2
        refreshInterval: 8
        repositories:
        - "${if stdenv.isDarwin then "/Users/tdoggett/Projects" else "/home/tdoggett/projects"}/nocoolnametom/nix-configs"
      weather:
        apiKey: "${import ../../keys/private/openweathermap_key.nix}"
        # From http://openweathermap.org/help/city_list.txt
        cityids:
        - 5391959
        - 5364226
        colors:
          current: "lightblue"
        enabled: true
        language: "EN"
        position:
          top: 0
          left: 4
          height: 1
          width: 1
        refreshInterval: 90
        tempUnit: "F"
      security:
        enabled: true
        position:
          top: 1
          left: 4
          height: 1
          width: 1
        refreshInterval: 360
      power:
        enabled: true
        position:
          top: 2
          left: 2
          height: 1
          width: 1
        refreshInterval: 15
      hackernews:
        enabled: true
        numberOfStories: 15
        position:
          top: 3
          left: 0
          height: 1
          width: 3
        storyType: top
        refreshInterval: 900
      jenkins:
        apiKey: "${import ../../keys/private/jenkins_api_key.nix}"
        enabled: false
        position:
          top: 4
          left: 0
          height: 1
          width: 5
        refreshInterval: 300
        url: "http://agentplatform-jenkins-master.sv2.trulia.com:8080/view/APOPS/job/APOPS.crm-web-ui.Deploy.PROD/"
        user: "tdoggett"
        verifyServerCertificate: false
''