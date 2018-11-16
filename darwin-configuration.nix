{ lib, config, pkgs, ... }:

with pkgs; let
  sessionVariables = (import ./sessionVariables {
    inherit pkgs;
  });
  extraHosts = ''
    # NixOps Testing
    192.168.56.101  cesletterbox.com www.cesletterbox.com

    # These are because the office DNS doesn't work well with ChunkWM,
    # so I preceed it with Google's 8.8.8.8 in settings, but that
    # breaks the following URIs.
    10.202.8.69     splunk.zillow.local lyn-splunk.zillow.local
    172.19.13.128   jira.corp.trulia.com
    172.19.14.104   fedevdb3.sv2.trulia.com
    172.19.51.98    feutil1.sv2.trulia.com
    172.19.56.41    stage-user-profile-service.sv2.trulia.com user-profile-service.sv2.trulia.com
    172.19.56.53    stash.sv2.trulia.com
    172.19.56.81    artifact-repo.sv2.trulia.com
    172.19.58.214   npm-int-0-1.sv2.trulia.com
    172.19.58.234   agentplatform-jenkins-master.sv2.trulia.com
    172.22.14.78    ric-zit-jet-001.zillow.local
    192.168.245.78  zwiki.zillowgroup.net
    10.130.128.216  gitlab.int.ap.truaws.com
    10.202.8.73     splunk.zillowgroup.net
  '';
in {
  imports = [
    ./overlays
  ];

  networking.hostName = "tdoggett4";
  networking.knownNetworkServices = [
    # "LPSS Serial Adapter (1)"
    # "LPSS Serial Adapter (2)"
    "USB 10/100/1000 LAN"
    "Thunderbolt Ethernet Slot 1"
    "Wi-Fi"
    # "Bluetooth PAN"
    # "Thunderbolt Bridge"
  ];
  networking.dns = [
    "8.8.8.8"
    "8.8.4.4"
    "10.6.106.138"
    "10.6.106.139"
  ];
  networking.search = [
    "zillow.local"
  ];

  environment.systemPackages = callPackage ./installList { };
  environment.variables = sessionVariables;
  environment.etc = (
    {}
    // (pkgs.myFiles.etc.hosts { inherit extraHosts; hostName = "${config.networking.hostName}.local"; })
    // pkgs.myFiles.etc.ssh_config
    // pkgs.myFiles.etc.trulia_server
    # This is just so we can run the nixos-config files from MacOS for testing without worrying about referencing a missing file
    // pkgs.myFiles.etc.nixos_hardware_configuration
  );

  nixpkgs.config.allowUnsupportedSystem = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreeRedistributable = true;

  system.defaults.LaunchServices.LSQuarantine = true;
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-time-modifier = "0.5";
  system.defaults.dock.dashboard-in-overlay = true;
  system.defaults.dock.enable-spring-load-actions-on-all-items = true;
  system.defaults.dock.expose-animation-duration = "0.12";
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.show-process-indicators = true;
  system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder._FXShowPosixPathInTitle = true;

  environment.systemPath = [
    "${builtins.getEnv "HOME"}/bin"
    "/usr/local/sbin"
  ];

  environment.postBuild = ''
    if [[ ! -e /etc/nix/docker_rsa ]]; then
      echo "Missing /etc/nix/docker_rsa!"
      echo "Please run the following command:"
      echo "    sudo cp ${pkgs.mine.nixDocker.pkg}/ssh/insecure_rsa /etc/nix/docker_rsa && sudo chmod 0600 /etc/nix/docker_rsa"
    fi
  '';

  # This keeps the local copy of nixpkgs up to date, but currently it's not doing anything
  # launchd.user.agents.fetch-nixpkgs = {
  #   command = "${git}/bin/git -C ~/.nix-defexpr/nixpkgs fetch origin master";
  #   environment.GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  #   serviceConfig.KeepAlive = false;
  #   serviceConfig.ProcessType = "Background";
  #   serviceConfig.StartInterval = 360;
  # };

  launchd.user.agents.chwm-sa = {
    command = "${pkgs.mine.chunkwm.core}/bin/chunkwm --load-sa";
    serviceConfig.KeepAlive = false;
    serviceConfig.ProcessType = "Background";
    serviceConfig.RunAtLoad = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.activate-system.enable = true;
  services.nix-daemon = {
    enable = true;
  };
  nix.gc.automatic = true;
  nix.package = nix;

  programs.vim = with pkgs.appConfigs.vim; {
    inherit vimConfig;
    enable = true;
    enableSensible = true;
    extraKnownPlugins = {
      vim-jsx = vimUtils.buildVimPluginFrom2Nix {
        name = "vim-javascript-2018-02-19";
        src = fetchgit {
          url = "git://github.com/mxw/vim-jsx";
          rev = "52ee8bb9f4b53e9bcb38c95f9839ec983bcf7f9d";
          sha256 = "17pffzwnvsimnnr4ql1qirdh4a0sqqsmcwfiqqzgglvsnzw5vpls";
        };
        dependencies = [];
      };
      vim-javascript-libraries-syntax = vimUtils.buildVimPluginFrom2Nix {
        name = "vim-javascript-libraries-syntax-2018-02-22";
        src = fetchgit {
          url = "https://github.com/othree/javascript-libraries-syntax.vim";
          rev = "2f812813cda79a3fbd53a50c57441fe58d3109cd";
          sha256 = "0k0zcdz9y1mwhdvkn7hsavij658ji15qdamfr1709rp40lv4673c";
        };
        dependencies = [];
      };
    };
    plugins = [{
      names = knownPlugins;
    }];
    vimOptions = {};
  };

  nix.extraOptions = ''
    keep-derivations = true
    keep-outputs = true
    gc-keep-derivations = true
    gc-keep-outputs = true
  '';

  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;
  programs.tmux.enableMouse = true;
  programs.tmux.enableFzf = true;
  programs.tmux.enableVim = true;

  programs.tmux.tmuxConfig = ''
    bind-key -n M-r run "tmux send-keys -t .+ C-l Up Enter"
    bind-key -n M-R run "tmux send-keys -t $(hostname -s | awk -F'-' '{print tolower($NF)}') C-l Up Enter"
    bind 0 set status
    bind S choose-session
    bind-key -r "<" swap-window -t -1
    bind-key -r ">" swap-window -t +1
    set -g status-bg black
    set -g status-fg white
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash = {
    enable = true;
    enableCompletion = false;
    interactiveShellInit = ''
      eval "$(${fasd}/bin/fasd --init auto)"
      export NIX_PATH=darwin=$NIX_USER_PROFILE_DIR/channels/darwin:darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH
    '';
  };
  # programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  services.mopidy.enable = false;
  services.mopidy.mediakeys.enable = false;

  services.chunkwm = with pkgs.mine.chunkwm; {
    inherit extraConfig;
    inherit plugins;
    enable = true;
    package = core;
    hotload = true;
  };

  services.skhd = {
    enable = true;
    skhdConfig = pkgs.appConfigs.skhd;
  };

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = pkgs.mine.nixDocker.hostname;
      sshUser = "root";
      sshKey = "/etc/nix/docker_rsa";
      systems = [ "x86_64-linux" ];
      maxJobs = 2;
    }
  ];
}
