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
          primary = true;
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
        };
        Gmail = {
          flavor = "plain";
          address = "nocoolnametom@gmail.com";
          userName = "nocoolnametom@gmail.com";
          realName = "Tom Doggett";
          imap = {
            host = "imap.gmail.com";
            port = 993;
            tls = {
              enable = true;
              useStartTls = true;
            };
          };
          smtp = {
            host = "smtp.gmail.com";
            port = 587;
            tls = {
              enable = true;
              useStartTls = true;
            };
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
      # signing = {
      #   # Note that this key needs to be imported to gpg!
      #   key = "5279843C73EB8029F9F6AF0EC4252D5677A319CA";
      #   signByDefault = true;
      # };
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
      matchBlocks = pkgs.callPackage ./sshConfig {};
    };

    programs.bash = {
      enableAutojump = true;
      initExtra = ''
        eval "$(${pkgs.fasd}/bin/fasd --init auto)"
      '';
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
      enable = true;
      windowManager = {
        i3 = {
          package = pkgs.i3;
          config = ( let
            hyper = "Shift+Mod1+Control+Mod4";
            meh = "Shift+Mod1+Control";
            shalt = "Shift+Mod1";
            mod = "Mod4";
            MainWS = "\"1: Main \"";
            DevWS = "\"2: Dev \"";
            InfoWS = "\"3: Info \"";
            PersonalWS = "\"4: Personal \"";
            PostmanWS = "\"5: Postman\"";
            MusicWS = "\"6: Music \"";
            DatabaseWS = "\"7: Database \"";
            ws8 = "8";
            ws9 = "9";
            ws10 = "10";
          in {
            fonts = ["Liberation Sans Narrow 11"];
            window = {
              titlebar = true;
              border = 2;
              hideEdgeBorders = "smart";
            };
            floating = {
              titlebar = true;
              border = 2;
              modifier = "${mod}";
              criteria = [
                { window_role="app"; title="Authy"; }
                { window_role="pop-up"; title="Zillow Group, Inc. - Sign In - Google Chrome"; }
              ];
            };
            focus = {
              newWindow = "smart";
              followMouse = true;
              forceWrapping = false;
            };
            # Assignments are made in the layouts
            assigns = {};
            keybindings = {
              # exit i3 and logout
              "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'poweroff'\" ";

              # start a terminal
              "${mod}+Return" = "exec termite -e 'zsh'";

              # kill focused window
              "${mod}+Shift+q" = "kill";

              # start dmenu
              "${mod}+d" = "exec --no-startup-id i3-dmenu-desktop";

              # change focus
              "${hyper}+h"   = "focus left";
              "${hyper}+j"   = "focus down";
              "${hyper}+k"   = "focus up";
              "${hyper}+l"   = "focus right";
              "${mod}+Left"  = "focus left";
              "${mod}+Down"  = "focus down";
              "${mod}+Up"    = "focus up";
              "${mod}+Right" = "focus right";

              # move focused window
              "${meh}+h"           = "move left";
              "${meh}+j"           = "move down";
              "${meh}+k"           = "move up";
              "${meh}+l"           = "move right";
              "${mod}+Shift+Left"  = "move left";
              "${mod}+Shift+Down"  = "move down";
              "${mod}+Shift+Up"    = "move up";
              "${mod}+Shift+Right" = "move right";

              # split horizontally
              "${mod}+h" = "split h";

              # split vertically
              "${mod}+v" = "split v";

              # container layouts
              "${mod}+s" = "layout stacking";
              "${mod}+w" = "layout tabbed";
              "${mod}+e" = "layout toggle split";

              # fullscreen toggle
              "${mod}+f" = "fullscreen toggle";

              # floating toggle
              "${mod}+Shift+space" = "floating toggle";

              # focus between floating and tiled containers
              "${mod}+space" = "focus mode_toggle";

              # focus on parent
              "${mod}+a" = "focus parent";

              # switch to workspace
              "${mod}+1" = "workspace ${MainWS}";
              "${mod}+2" = "workspace ${DevWS}";
              "${mod}+3" = "workspace ${InfoWS}";
              "${mod}+4" = "workspace ${PersonalWS}";
              "${mod}+5" = "workspace ${PostmanWS}";
              "${mod}+6" = "workspace ${MusicWS}";
              "${mod}+7" = "workspace ${DatabaseWS}";
              "${mod}+8" = "workspace ${ws8}";
              "${mod}+9" = "workspace ${ws9}";
              "${mod}+0" = "workspace ${ws10}";

              # Move focused container to workspace
              "${mod}+Shift+1" = "move container to workspace ${MainWS}";
              "${mod}+Shift+2" = "move container to workspace ${DevWS}";
              "${mod}+Shift+3" = "move container to workspace ${InfoWS}";
              "${mod}+Shift+4" = "move container to workspace ${PersonalWS}";
              "${mod}+Shift+5" = "move container to workspace ${PostmanWS}";
              "${mod}+Shift+6" = "move container to workspace ${MusicWS}";
              "${mod}+Shift+7" = "move container to workspace ${DatabaseWS}";
              "${mod}+Shift+8" = "move container to workspace ${ws8}";
              "${mod}+Shift+9" = "move container to workspace ${ws9}";
              "${mod}+Shift+0" = "move container to workspace ${ws10}";

              # reload configuration (home-manager will take care of this for you most of the time)
              "${mod}+Shift+c" = "reload";

              # restart i3 in place
              "${mod}+Shift+r" = "restart";

              # enter resize mode
              "${mod}+r" = "mode \"resize\" ";

              # mopidy music server control
              "${shalt}+h" = "exec ${pkgs.mpc_cli}/bin/mpc volume +1";
              "${shalt}+j" = "exec ${pkgs.mpc_cli}/bin/mpc toggle";
              "${shalt}+k" = "exec ${pkgs.mpc_cli}/bin/mpc next";
              "${shalt}+l" = "exec ${pkgs.mpc_cli}/bin/mpc volume -1";
            };
            colors = {
              background = "$ffffff";
              focused = {
                border = "#4c7899";
                background = "#285577";
                text = "#ffffff";
                indicator = "#2e9ef4";
                childBorder = "#285577";
              };
              focusedInactive = {
                border = "#333333";
                background = "#5f676a";
                text = "#ffffff";
                indicator = "#484e50";
                childBorder = "#5f676a";
              };
              unfocused = {
                border = "#333333";
                background = "#222222";
                text = "#888888";
                indicator = "#292d2e";
                childBorder = "#222222";
              };
              urgent = {
                border = "#2f343a";
                background = "#900000";
                text = "#ffffff";
                indicator = "#900000";
                childBorder = "#900000";
              };
              placeholder = {
                border = "#000000";
                background = "#0c0c0c";
                text = "#ffffff";
                indicator = "#000000";
                childBorder = "#0c0c0c";
              };
            };
            modes = {
              resize = {
                "j"         = "resize shrink width  10 px or 10 ppt";
                "k"         = "resize grow   height 10 px or 10 ppt";
                "l"         = "resize shrink height 10 px or 10 ppt";
                "semicolon" = "resize grow   width  10 px or 10 ppt";
                "Left"      = "resize shrink width  10 px or 10 ppt";
                "Down"      = "resize grow   height 10 px or 10 ppt";
                "Up"        = "resize shrink height 10 px or 10 ppt";
                "Right"     = "resize grow   width  10 px or 10 ppt";

                # back to normal
                "Return" = "mode \"default\" ";
                "Escape" = "mode \"default\" ";
              };
            };
            bars = [
              {
                mode = "dock";
                hiddenState = "hide";
                position = "top";
                workspaceButtons = true;
                # statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ${pkgs.appConfigs.i3blocks}";
              }
            ];
            startup = [
              {
                command = "${pkgs.qscreenshot}/bin/qScreenshot";
                notification = true;
              }
              {
                command = "${pkgs.termite}/bin/termite -c ~/.config/termite/config -t home --directory=~ -e '${pkgs.zsh}'";
                notification = true;
              }
              {
                command = "i3-msg \"workspace ${MainWS};\" ";
                notification = false;
              }
              {
                command = "nm-applet";
                notification = false;
              }
              {
                command = "insync start";
                notification = false;
              }
            ];
          });
          extraConfig = ''
            # Pulse Audio controls
            bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
            bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
            bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound

            # Sreen brightness controls
            bindsym XF86MonBrightnessUp exec xbacklight -inc 10 # increase screen brightness
            bindsym XF86MonBrightnessDown exec xbacklight -dec 10 # decrease screen brightness
          '';
        };
      };
      initExtra = ''
        ${if isVmware then "sudo ${pkgs.mine.scripts.vmware_login_mount};" else ""}
        # systemctl --user restart random-background
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
    programs.vim.enable = true;
    programs.termite.enable = true;
    programs.zsh.enable = true;
    xsession.enable = true;
    xsession.windowManager.i3.enable = true;

    services.compton.enable = true;
    services.dunst.enable = true;
    services.gpg-agent.enable = false;
    services.keybase.enable = true;
    services.kbfs.enable = true;
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

  # (lib.mkIf verifyRepos {
  #   home.activation.tomDoggettInitVerifyRepos = dagEntryAfter ["tomDoggettInit"] ''
  #     ${pkgs.mine.scripts.zg_startup}
  #     ${pkgs.mine.scripts.personal_startup}
  #   '';
  # })
]
