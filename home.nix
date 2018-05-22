{ pkgs, config, lib, ... }:

with pkgs; let
  files = callPackage ./files {};
  sessionVariables = (recurseIntoAttrs (callPackage ./sessionVariables { })).variables;
  i3Config = (recurseIntoAttrs (callPackage ./i3 { config = config; }));
  mine = callPackage ./systemPackages/mine {};
in {
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  home.file = import ./scripts { pkgs = pkgs; stdenv = stdenv; config = config; };

  programs.git = {
    enable = true;
    userName = "Tom Doggett";
    userEmail = "nocoolnametom@gmail.com";
    signing = {
      # Note that this key needs to be imported to gpg!
      key = "5279843C73EB8029F9F6AF0EC4252D5677A319CA";
      signByDefault = true;
    };
    aliases = {
      co = "checkout";
    };
    extraConfig = {
      log = {
        decorate = "full";
      };
      rebase = {
        autostash = true;
      };
      pull = {
        rebase = true;
      };
      stash = {
        showPatch = true;
      };
      "color \"status\"" = {
        added = "green";
        changed = "yellow bold";
        untracked = "red bold";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = callPackage ./sshConfig {};
  };

  programs.bash = if stdenv.isDarwin then {
    enable = false; # We handle bash in darwin-configuration for Mac OS
  } else {
    enable = true;
    enableAutojump = true;
    initExtra = ''
      eval "$(${fasd}/bin/fasd --init auto)"
    '';
  };

  programs.feh = if stdenv.isDarwin then {
    enable = false;
  } else {
    enable = true;
  };

  programs.termite = if stdenv.isDarwin then {
    enable = false;
  } else {
    enable = true;
    allowBold = true;
    browser = config.home.file."bin/chrome-personal".target;
    clickableUrl = true;
    cursorBlink = "on";
    cursorShape = "block";
    font = "Consolas 11";
    mouseAutohide = true;
    scrollbackLines = 50000;
    searchWrap = true;
    urgentOnBell = true;
    audibleBell = false;
    dynamicTitle = true;
    fullscreen = false;
    scrollOnOutput = true;
    scrollOnKeystroke = true;
    filterUnmatchedUrls = false;
    scrollbar = "off";

    # Jelly Beans Color
    cursorColor = "#d7d7d7";
    foregroundColor = "#d7d7d7";
    foregroundBoldColor = "#d7d7d7";
    backgroundColor = "rgba(18, 18, 18, 0.8)";
    highlightColor = "#222222";
    colorsExtra = ''
      #Black
      color0  = #000000
      color8  = #535551
      #Red
      color1  = #ca674a
      color9  = #ea2828
      #Green
      color2  = #96a967
      color10 = #87dd32
      #Yellow
      color3  = #d3a94a
      color11 = #f7e44d
      #Blue
      color4  = #5778c1
      color12 = #6f9bca
      #Magenta
      color5  = #9c35ac
      color13 = #a97ca4
      #Cyan
      color6  = #6eb5f3
      color14 = #32dddd
      #White
      color7  = #a9a9a9
      color15 = #e9e9e7
    '';
  };

  programs.zsh = if stdenv.isDarwin then {
    enable = false; # We handle zsh in darwin-configuration for Mac OS
  } else {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
      eval "$(${fasd}/bin/fasd --init auto)"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      custom = "${builtins.getEnv "HOME"}/.zsh_custom";
      theme = "powerlevel9k/powerlevel9k";
    };
    sessionVariables = sessionVariables;
  };

  xdg = if stdenv.isDarwin then {
    enable = false;
  } else {
    enable = true;
    configFile = {} // i3Config.layouts;
  };

  services = if stdenv.isDarwin then {} else {
    compton = {
      enable = true;
    };
    dunst = {
      enable = true;
      settings = {
        global = {
          alignment = "center";
          allow_markup = true;
          bounce_freq = 0;
          dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
          follow = "keyboard";
          font = "Liberation Sans 12";
          format = "<b>%s</b>\n%b";
          geometry = "300x5-30+20";
          horizontal_padding = 8;
          idle_threshold = 120;
          ignore_newline = false;
          indicate_hidden = true;
          line_height = 0;
          markup = "full";
          monitor = 0;
          padding = 8;
          separator_color = "#585858";
          separator_height = 2;
          show_age_threshold = 60;
          sort = true;
          startup_notification = true;
          sticky_history = true;
          transparency = 0;
          word_wrap = true;
          icon_position = "left";
        };
        frame = {
          width = 1;
          color = "#383838";
        };
        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };
        urgency_low = {
          background = "#383A3B";
          foreground = "#FFFFFF";
          timeout = 10;
        };
        urgency_normal = {
          background = "#181818";
          foreground = "#E3C7AF";
          timeout = 900;
        };
        urgency_critical = {
          background = "#FD5F00";
          foreground = "#282226";
          timeout = 0;
        };
        irc = {
          appname = "weechat";
          icon = ./files/icon.png;
          format  = "%s: %b";
          urgency = "critical";
          background = "#FD5F00";
          foreground = "#282226";
        };
      };
    };
    gpg-agent = {
      enable = true;
    };
    keybase = {
      enable = true;
    };
    kbfs = {
      enable = false;
      mountPoint = "keybase";
      extraFlags = [
      ];
    };
    random-background = {
      enable = true;
      imageDirectory = "/mnt/vmware/wallpapers/";
      interval = "30 min";
    };
    screen-locker = {
      enable = false;
      inactiveInterval = 60;
      lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -g -t ' '";
    };
    unclutter = {
      enable = true;
      timeout = 5;
      extraOptions = [
        "exclude-root"
        "ignore-scrolling"
      ];
    };
  };

  xsession = if stdenv.isDarwin then {
    enable = false;
  } else {
    enable = true;
    windowManager = {
      i3 = i3Config.i3Config;
    };
    initExtra = ''
      sudo mkdir -p /mnt/vmware/{downloads,googledrive,googledrivezillow,projects,tdoggett}
      sudo vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/downloads /mnt/vmware/downloads
      sudo vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/googledrive /mnt/vmware/googledrive
      sudo vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/googledrivezillow /mnt/vmware/googledrivezillow
      sudo vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/projects /mnt/vmware/projects
      sudo vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/tdoggett /mnt/vmware/tdoggett
      sudo vmhgfs-fuse -o allow_other -o auto_unmount -o uid=1000 -o gid=1000 .host:/wallpapers /mnt/vmware/wallpapers
      sudo mount -a && systemctl --user restart random-background
      systemctl --user start compton.service
      ${mine.i3-gnome-pomodoro-mine}/bin/pomodoro-client daemon 4 --nagbar &
      xset dpms 90
      xset s off
      xrd -merge ~/.Xresources
      ${mine.i3-gnome-pomodoro-mine}/bin/pomodoro-client start && ${mine.i3-gnome-pomodoro-mine}/bin/pomodoro-client skip 
    '';
  };
}