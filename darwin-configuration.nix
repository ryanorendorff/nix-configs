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

  programs.vim = {
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
      names = pkgs.appConfigs.vim.knownPlugins;
    }];
    vimOptions = {};
    vimConfig = pkgs.appConfigs.vim.vimConfig;
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

  services.chunkwm = {
    enable = false;
    package = pkgs.mine.chunkwm.core;
    hotload = true;
    extraConfig = pkgs.mine.chunkwm.extraConfig;
    plugins = pkgs.mine.chunkwm.plugins;
  };

  services.skhd = {
    enable = false;
    package = skhd;
    skhdConfig = ''
      # enter fullscreen mode for the focused container
      alt - f : chunkc tiling::window --toggle fullscreen

      # change focus between tiling / floating windows
      shift + alt - space : chunkc tiling::window --toggle float

      # change layout of desktop
      alt - e : chunkc tiling::desktop --layout bsp
      alt - s : chunkc tiling::desktop --layout monocle

      # kill focused window
      shift + alt - q : chunkc tiling::window --close

      # change focus
      alt - h : chunkc tiling::window --focus west
      alt - j : chunkc tiling::window --focus south
      alt - k : chunkc tiling::window --focus north
      alt - l : chunkc tiling::window --focus east

      alt - p : chunkc tiling::window --focus prev
      alt - n : chunkc tiling::window --focus next

      # move focused window
      shift + alt - h : chunkc tiling::window --warp west
      shift + alt - j : chunkc tiling::window --warp south
      shift + alt - k : chunkc tiling::window --warp north
      shift + alt - l : chunkc tiling::window --warp east

      alt - r : chunkc tiling::desktop --rotate 90

      # move focused container to workspace
      shift + alt - m : chunkc tiling::window --send-to-desktop $(chunkc get _last_active_desktop)
      shift + alt - p : chunkc tiling::window --send-to-desktop prev
      shift + alt - n : chunkc tiling::window --send-to-desktop next
      shift + alt - 1 : chunkc tiling::window --send-to-desktop 1
      shift + alt - 2 : chunkc tiling::window --send-to-desktop 2
      shift + alt - 3 : chunkc tiling::window --send-to-desktop 3
      shift + alt - 4 : chunkc tiling::window --send-to-desktop 4
      shift + alt - 5 : chunkc tiling::window --send-to-desktop 5
      shift + alt - 6 : chunkc tiling::window --send-to-desktop 6

      # Resize windows
      shift + alt - a : chunkc tiling::window --use-temporary-ratio 0.05 --adjust-window-edge west; chunkc tiling::window --use-temporary-ratio -0.05 --adjust-window-edge east
      shift + alt - s : chunkc tiling::window --use-temporary-ratio 0.05 --adjust-window-edge south; chunkc tiling::window --use-temporary-ratio -0.05 --adjust-window-edge north
      shift + alt - w : chunkc tiling::window --use-temporary-ratio 0.05 --adjust-window-edge north; chunkc tiling::window --use-temporary-ratio -0.05 --adjust-window-edge south
      shift + alt - d : chunkc tiling::window --use-temporary-ratio 0.05 --adjust-window-edge east; chunkc tiling::window --use-temporary-ratio -0.05 --adjust-window-edge west
    '';
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
