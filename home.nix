{ pkgs, options, config, lib, ... }:

let
  verifyRepos = true;
  isVmware = false;
  configHome = if (lib.hasAttrByPath ["xdg" "configHome"] config) then config.xdg.configHome else "~/.config";
  homeDirectory = if (lib.hasAttrByPath ["home" "homeDirectory"] config) then config.home.homeDirectory else "~";
  sessionVariables = (pkgs.recurseIntoAttrs (import ./sessionVariables {
    inherit pkgs;
    vim = if (lib.hasAttrByPath ["programs" "vim" "package"] config) then config.programs.vim.package else pkgs.vim;
    }));
  addHomeFiles = myFiles: newFiles: lib.mkMerge([
    myFiles.bin.personal_startup
    myFiles.bin.sync_projects
    myFiles.bin.zg_backup
    myFiles.bin.zg_startup
    myFiles.bin.zgitclone
    myFiles.home.ideavim
    myFiles.home.muttrc
    myFiles.home.npmrc
    myFiles.home.wtfutil_gcal_token
    myFiles.home.zsh_themes_powerlevel9k
  ] ++ newFiles);
  addConfigFiles = myFiles: newFiles: lib.mkMerge([
    myFiles.xdg.rtv
    myFiles.xdg.wtfutil
  ] ++ newFiles);
  addDataFiles = myFiles: newFiles: lib.mkMerge([] ++ newFiles);
  dagEntryAnywhere = data: {
    inherit data;
    before = [];
    after = [];
  };
  dagEntryAfter = after: data: {
    inherit data after;
    before = [];
  };
  mutableDotfiles = toString ./mutableDotfiles;
in lib.mkMerge [
  {
    nixpkgs.overlays = [
      (import ./appConfigs/overlays.nix)
      (import ./cronJobs/overlays.nix)
      (import ./files/overlays.nix)
      (import ./pkgs/overlays.nix)
    ];
    programs.home-manager.enable = true;
    programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

    accounts.email = {
      maildirBasePath = config.home.homeDirectory + "/Mail";

      accounts = {
        Zillow = {
          primary = isVmware || pkgs.stdenv.isDarwin;
          address = "tdoggett@zillowgroup.com";
          userName = "tdoggett@zillowgroup.com";
          realName = "Tom Doggett";
          flavor = "plain";
          folders = {
            drafts = "Drafts";
            inbox = "Inbox";
            sent = "Sent";
            trash = "Trash";
          };
          imap = {
            host = "outlook.office365.com";
            port = 993;
            tls = {
              enable = true;
              useStartTls = true;
            };
          };
          smtp = {
            host = "outlook.office365.com";
            port = 587;
            tls = {
              enable = true;
              useStartTls = true;
            };
          };
          gpg = {
            key = "5279843C73EB8029F9F6AF0EC4252D5677A319CA";
            signByDefault = true;
            encryptByDefault = false;
          };
          maildir = {
            path = "zillow";
          };
          mbsync = {
            enable = true;
            patterns = [ "*" "!Archives" ];
          };
          notmuch = {
            enable = true;
          };
          signature = {
            text = ''
              --
              Tom Doggett
              Software Engineer
              Zillow Group
              tdoggett@zillowgroup.com
            '';
            showSignature = "append";
          };
        };
        Gmail = {
          primary = pkgs.stdenv.isLinux && !isVmware;
          flavor = "gmail.com";
          address = "nocoolnametom@gmail.com";
          realName = "Tom Doggett";
          gpg = {
            key = "5279843C73EB8029F9F6AF0EC4252D5677A319CA";
            signByDefault = true;
            encryptByDefault = false;
          };
          maildir = {
            path = "gmail";
          };
          mbsync = {
            enable = true;
            patterns = [ "*" "!Archives" ];
          };
          notmuch = {
            enable = true;
          };
          signature = {
            text = "";
            showSignature = "none";
          };
        };
      };
    };

    home.activation.tomDoggettInit = dagEntryAnywhere ''
      cp -fL ${pkgs.appConfigs.weechat.icon} ${mutableDotfiles}/weechat/.weechat/icon.png
      cp -fL ${pkgs.mine.weechatPlugins.autosort}/autosort.py ${mutableDotfiles}/weechat-plugins/.weechat/python/autosort.py
      cp -fL ${pkgs.mine.weechatPlugins.buffer_autoset}/buffer_autoset.py ${mutableDotfiles}/weechat-plugins/.weechat/python/buffer_autoset.py
      cp -fL ${pkgs.mine.weechatPlugins.text_item}/text_item.py ${mutableDotfiles}/weechat-plugins/.weechat/python/text_item.py
      cp -fL ${pkgs.mine.weechatPlugins.urlserver}/urlserver.py ${mutableDotfiles}/weechat-plugins/.weechat/python/urlserver.py
      cp -fL ${pkgs.mine.weechatPlugins.wee-slack}/wee_slack.py ${mutableDotfiles}/weechat-plugins/.weechat/python/wee_slack.py
      cp -fL ${pkgs.mine.weechatPlugins.highmon}/highmon.pl ${mutableDotfiles}/weechat-plugins/.weechat/perl/highmon.pl
      cp -fL ${pkgs.mine.weechatPlugins.perlexec}/perlexec.pl ${mutableDotfiles}/weechat-plugins/.weechat/perl/perlexec.pl
      stow -d "${mutableDotfiles}" -t ${homeDirectory} bin weechat weechat-plugins
    '';

    home.activation."tomDoggettUpdateNpmrc" = dagEntryAfter ["tomDoggettInit"] ''
      touch ~/.npmrc && $(sed "/^[^/]/ d" ~/.npmrc > ~/.npmrcnew) && cat ~/.npmrc.immutable > ~/.npmrc && cat ~/.npmrcnew >> ~/.npmrc && rm ~/.npmrcnew
    '';

    xdg = {
      enable = true;
    };

    # Darwin's packages are system-wide and are handled via running `darwin-rebuild` using `./installList`
    home.packages = if pkgs.stdenv.isDarwin then [] else pkgs.callPackage ./installList {};

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

    programs.go = {
      packages = {
        "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
        "golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = pkgs.callPackage ./sshConfig {};
    };

    programs.bash = {
      enableAutojump = true;
      initExtra = ''
        eval "$(${pkgs.fasd}/bin/fasd --init auto)"
      '';
    };

    programs.firefox = {
      enableAdobeFlash = true;
      enableGoogleTalk = true;
      enableIcedTea = true;
    };

    programs.vim = {
      plugins = pkgs.appConfigs.vim.knownPlugins;
      extraConfig = pkgs.appConfigs.vim.vimConfig;
    };

    programs.termite = {
      allowBold = true;
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

    programs.zsh = {
      enableAutosuggestions = true;
      initExtra = ''
        eval "$(${pkgs.fasd}/bin/fasd --init auto)"
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

    services = {
      dunst = {
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
            icon = pkgs.appConfigs.weechat.icon;
            format  = "%s: %b";
            urgency = "critical";
            background = "#FD5F00";
            foreground = "#282226";
          };
        };
      };
      kbfs = {
        mountPoint = "keybase";
        extraFlags = [
        ];
      };
      random-background = {
        imageDirectory = "${homeDirectory}/wallpapers/";
        interval = "30 min";
      };
      screen-locker = {
        inactiveInterval = 60;
        lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -g -t ' '";
      };
      unclutter = {
        timeout = 5;
        extraOptions = [
          "exclude-root"
          "ignore-scrolling"
        ];
      };
    };

    xsession = {
      windowManager = {
        i3 = pkgs.appConfigs.i3.i3Config { inherit isVmware; };
      };
      initExtra = ''
        ${if isVmware then "sudo ${pkgs.mine.scripts.vmware_login_mount};" else ""}
        # systemctl --user restart random-background
        [ -e /dev/mmcblk0p1 ] && udiskctl mount -b /dev/mmcblk0p1
        systemctl --user start compton.service
        systemctl --user start keybase.service
        systemctl --user start kbfs.service
        ${pkgs.mine.python36Packages.i3-gnome-pomodoro}/bin/pomodoro-client daemon 4 --nagbar &
        xset dpms 90
        xset s off
        xrd -merge ~/.Xresources
        ${pkgs.mine.python36Packages.i3-gnome-pomodoro}/bin/pomodoro-client start && ${pkgs.mine.python36Packages.i3-gnome-pomodoro}/bin/pomodoro-client skip 
      '';
    };
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    programs.bash.enable = false;
    programs.feh.enable = false;
    programs.vim.enable = false;
    programs.termite.enable = false;
    programs.zsh.enable = false;
    xsession.enable = false;

    home.file = addHomeFiles pkgs.myFiles [
      pkgs.myFiles.bitbar.calendar
      pkgs.myFiles.bitbar.google_music
      pkgs.myFiles.bitbar.chunkwm_skhd
    ];

    xdg.configFile = addConfigFiles pkgs.myFiles [];

    xdg.dataFile = addDataFiles pkgs.myFiles [
      pkgs.myFiles.xdg.first_run
    ];

    home.activation.tomDoggettInitDarwin = dagEntryAfter ["tomDoggettInit"] ''
      cp -fL ${pkgs.mine.weechatPlugins.notification_center}/notification_center.py ${mutableDotfiles}/weechat-plugins/.weechat/python/notification_center.py
      stow -d "${mutableDotfiles}" -t ${homeDirectory} vscode_macos
    '';
  })

  (lib.mkIf pkgs.stdenv.isLinux {
    programs.bash.enable = true;
    programs.feh.enable = true;
    programs.firefox.enable = true;
    programs.go.enable = true;
    programs.vim.enable = true;
    programs.termite.enable = true;
    programs.zsh.enable = true;
    xsession.enable = true;
    xsession.windowManager.i3.enable = true;

    services.compton.enable = true;
    services.dunst.enable = true;
    services.gpg-agent.enable = true;
    services.keybase.enable = true;
    services.kbfs.enable = true;
    services.network-manager-applet.enable = true;
    # services.random-background.enable = true;
    services.screen-locker.enable = false;
    services.unclutter.enable = true;

    home.file = addHomeFiles pkgs.myFiles [];

    xdg.configFile = addConfigFiles pkgs.myFiles [
      pkgs.myFiles.xdg.i3blocks
    ];

    xdg.dataFile = addDataFiles pkgs.myFiles [];

    home.activation.tomDoggettInitLinux = dagEntryAfter ["tomDoggettInit"] ''
      cp -fL ${pkgs.mine.weechatPlugins.notify_send}/notify_send.py ${mutableDotfiles}/weechat-plugins/.weechat/python/notify_send.py
      stow -d "${mutableDotfiles}" -t ${homeDirectory} vscode
    '';
  })

  (lib.mkIf (verifyRepos && (pkgs.stdenv.isDarwin || isVmware)) {
    home.activation.tomDoggettInitVerifyRepos = dagEntryAfter ["tomDoggettInit"] ''
      ${pkgs.mine.scripts.zg_startup}
      ${pkgs.mine.scripts.personal_startup}
    '';
  })
]
