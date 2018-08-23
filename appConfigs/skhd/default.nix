{ pkgs, ... }:

let
  chunkc = "${pkgs.mine.chunkwm.core}/bin/chunkc";
  shalt = "shift + alt";
  meh = "ctrl + ${shalt}";
  hyper = "cmd + ${meh}";
in ''
  # Ignore MacOS screenshot command
  cmd + shift - 4 -> : ${chunkc} border::clear

  # enter fullscreen mode for the focused container
  alt - f : ${chunkc} tiling::window --toggle fullscreen

  # change focus between tiling / floating windows
  ${shalt} - space : ${chunkc} tiling::window --toggle float

  # change layout of desktop
  alt - e : ${chunkc} tiling::desktop --layout bsp
  alt - s : ${chunkc} tiling::desktop --layout monocle

  # kill focused window
  ${shalt} - q : ${chunkc} tiling::window --close

  # change focus
  alt - h : ${chunkc} tiling::window --focus west
  alt - j : ${chunkc} tiling::window --focus south
  alt - k : ${chunkc} tiling::window --focus north
  alt - l : ${chunkc} tiling::window --focus east

  alt - p : ${chunkc} tiling::window --focus prev
  alt - n : ${chunkc} tiling::window --focus next

  # move focused window
  ${shalt} - h : ${chunkc} tiling::window --warp west
  ${shalt} - j : ${chunkc} tiling::window --warp south
  ${shalt} - k : ${chunkc} tiling::window --warp north
  ${shalt} - l : ${chunkc} tiling::window --warp east

  alt - r : ${chunkc} tiling::desktop --rotate 90

  # move focused container to workspace
  ${shalt} - 1 : ${chunkc} tiling::window --send-to-desktop 1
  ${shalt} - 2 : ${chunkc} tiling::window --send-to-desktop 2
  ${shalt} - 3 : ${chunkc} tiling::window --send-to-desktop 3
  ${shalt} - 4 : ${chunkc} tiling::window --send-to-desktop 4
  ${shalt} - 5 : ${chunkc} tiling::window --send-to-desktop 5
  ${shalt} - 6 : ${chunkc} tiling::window --send-to-desktop 6
  ${shalt} - 7 : ${chunkc} tiling::window --send-to-desktop 7
  ${shalt} - 8 : ${chunkc} tiling::window --send-to-desktop 8
  ${shalt} - 9 : ${chunkc} tiling::window --send-to-desktop 9

  # move focus to workspace
  ${meh} - 1 : ${chunkc} tiling::desktop --focus 1
  ${meh} - 2 : ${chunkc} tiling::desktop --focus 2
  ${meh} - 3 : ${chunkc} tiling::desktop --focus 3
  ${meh} - 4 : ${chunkc} tiling::desktop --focus 4
  ${meh} - 5 : ${chunkc} tiling::desktop --focus 5
  ${meh} - 6 : ${chunkc} tiling::desktop --focus 6
  ${meh} - 7 : ${chunkc} tiling::desktop --focus 7
  ${meh} - 8 : ${chunkc} tiling::desktop --focus 8
  ${meh} - 9 : ${chunkc} tiling::desktop --focus 9

  # create desktop, move window and follow focus
  ${meh} - n : ${chunkc} tiling::desktop --create; ids=$(${chunkc} tiling::query --desktops-for-monitor $(${chunkc} tiling::query --monitor-for-desktop $(${chunkc} tiling::query --desktop id))); ${chunkc} tiling::window --send-to-desktop $(echo ${"$"}{ids##* }); ${chunkc} tiling::desktop --focus $(echo ${"$"}{ids##* })

  # Resize windows
  ${shalt} - a : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge west; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge east
  ${shalt} - s : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge south; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge north
  ${shalt} - w : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge north; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge south
  ${shalt} - d : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge east; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge west
''
