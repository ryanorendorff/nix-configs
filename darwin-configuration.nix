{ lib, config, pkgs, ... }:

with pkgs; let
  sessionVariables = (import ./sessionVariables {
    inherit pkgs;
  });
in {
  imports = [
    ./overlays
  ];

  environment.systemPackages = callPackage ./installList { };
  environment.variables = sessionVariables;
  environment.etc = (
    {}
    // pkgs.myFiles.etc.hosts
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

  launchd.user.agents.fetch-nixpkgs = {
    command = "${git}/bin/git -C ~/.nix-defexpr/nixpkgs fetch origin master";
    environment.GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    serviceConfig.KeepAlive = false;
    serviceConfig.ProcessType = "Background";
    serviceConfig.StartInterval = 360;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
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
    gc-keep-derivations = true
    gc-keep-outputs = true
  '';

  programs.nix-index.enable = true;

  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;
  programs.tmux.enableMouse = true;
  programs.tmux.enableFzf = true;
  programs.tmux.enableVim = true;
  programs.tmux.iTerm2 = true;

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
