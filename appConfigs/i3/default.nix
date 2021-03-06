{ pkgs, lib, ... }:

let
  MainWS     = "1:main";
  DevWS      = "2:dev";
  InfoWS     = "3:info";
  PersonalWS = "4:personal";
  PostmanWS  = "5:postman";
  MusicWS    = "6:music";
  DatabaseWS = "7:database";
  KeepassWS  = "8:keepass";
  ws9        = "9";
  ws10       = "10";
  monitor1 = "Virtual1";
  monitor2 = "Virtual3";
  monitor3 = "Virtual2";
in {
  i3Config = { isVmware ? false }: {
    package = pkgs.i3;
    config = ( let
      hyper = "Shift+Mod1+Control+Mod4";
      meh = "Shift+Mod1+Control";
      shalt = "Shift+Mod1";
      mod = "Mod4";
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
        "${mod}+Shift+h" = "exec \"i3-nagbar -t warning -m 'You pressed the hibernate shortcut. Do you really want to hiberate? This will close the encrypted drive.' -b 'Yes, hibernate' 'systemctl hibernate'\" ";

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
        "${mod}+8" = "workspace ${KeepassWS}";
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
        "${mod}+Shift+8" = "move container to workspace ${KeepassWS}";
        "${mod}+Shift+9" = "move container to workspace ${ws9}";
        "${mod}+Shift+0" = "move container to workspace ${ws10}";

        # reload configuration (home-manager will take care of this for you most of the time)
        "${mod}+Shift+c" = "reload";

        # restart i3 in place
        "${mod}+Shift+r" = "restart";

        # enter resize mode
        "${mod}+r" = "mode \"resize\" ";

        # mopidy music server control
        # "${shalt}+h" = "exec ${pkgs.mpc_cli}/bin/mpc volume +1";
        # "${shalt}+j" = "exec ${pkgs.mpc_cli}/bin/mpc toggle";
        # "${shalt}+k" = "exec ${pkgs.mpc_cli}/bin/mpc next";
        # "${shalt}+l" = "exec ${pkgs.mpc_cli}/bin/mpc volume -1";
      
        # Google Play Music Desktop Player control
        "${shalt}+h" = "exec ${pkgs.playerctl}/bin/playerctl volume +1";
        "${shalt}+j" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "${shalt}+k" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "${shalt}+l" = "exec ${pkgs.playerctl}/bin/playerctl volume -1";
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
        # {
        #   mode = "dock";
        #   hiddenState = "hide";
        #   position = "top";
        #   workspaceButtons = true;
        #   statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ${pkgs.appConfigs.i3blocks}";
        # }
      ];
      startup = [
        {
          command = "${pkgs.qscreenshot}/bin/qScreenshot";
          notification = true;
        }
        {
          command = "i3-msg \"workspace ${KeepassWS}; exec ${pkgs.keepassxc}/bin/keepassxc\" ";
          notification = false;
        }
        {
          command = "i3-msg \"workspace ${MainWS};\"; exec ${pkgs.termite}/bin/termite -c ~/.config/termite/config -t home --directory=~ -e '${pkgs.zsh}'";
          notification = false;
        }
        {
          command = "insync start";
          notification = false;
        }
      ] ++ lib.optionals isVmware [
        {
          command = "i3-msg \"workspace ${DevWS}; append_layout ${./layout2.json}\" ";
          notification = false;
        }
        {
          command = "i3-msg \"workspace ${InfoWS}; append_layout ${./layout3.json}\" ";
          notification = false;
        }
        {
          command = "i3-msg \"workspace ${PersonalWS}; append_layout ${./layout4.json}\" ";
          notification = false;
        }
        {
          command = "i3-msg \"workspace ${PostmanWS}; append_layout ${./layout5.json}\" ";
          notification = false;
        }
        {
          command = "i3-msg \"workspace ${MainWS}; append_layout ${./layout1.json}\" ";
          notification = false;
        }
      ];
    });
    extraConfig = ''
      # Pulse Audio controls
      bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% # && pkill -RTMIN+10 i3blocks
      bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% # && pkill -RTMIN+10 i3blocks
      bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # && pkill -RTMIN+10 i3blocks

      # Sreen brightness controls
      bindsym XF86MonBrightnessUp exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 5 # increase screen brightness
      bindsym XF86MonBrightnessDown exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 5 # decrease screen brightness

      # Keyboard brightness controls
      bindsym XF86KbdBrightnessUp exec ${pkgs.mine.scripts.asus-keyboard} up
      bindsym XF86KbdBrightnessDown exec ${pkgs.mine.scripts.asus-keyboard} down
    '' + (if isVmware then ''
      workspace ${MainWS} output ${monitor1}
      workspace ${PostmanWS} output ${monitor1}
      workspace ${PersonalWS} output ${monitor1}
      workspace ${DevWS} output ${monitor2}
      workspace ${InfoWS} output ${monitor3}
      workspace ${MusicWS} output ${monitor3}
      workspace ${DatabaseWS} output ${monitor2}
    '' else "");
  };
}
