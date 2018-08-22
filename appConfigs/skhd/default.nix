{ pkgs, ... }:

let
  chunkc = "${pkgs.mine.chunkwm.core}/bin/chunkc";
in ''
  # enter fullscreen mode for the focused container
  alt - f : ${chunkc} tiling::window --toggle fullscreen

  # change focus between tiling / floating windows
  shift + alt - space : ${chunkc} tiling::window --toggle float

  # change layout of desktop
  alt - e : ${chunkc} tiling::desktop --layout bsp
  alt - s : ${chunkc} tiling::desktop --layout monocle

  # kill focused window
  shift + alt - q : ${chunkc} tiling::window --close

  # change focus
  alt - h : ${chunkc} tiling::window --focus west
  alt - j : ${chunkc} tiling::window --focus south
  alt - k : ${chunkc} tiling::window --focus north
  alt - l : ${chunkc} tiling::window --focus east

  alt - p : ${chunkc} tiling::window --focus prev
  alt - n : ${chunkc} tiling::window --focus next

  # move focused window
  shift + alt - h : ${chunkc} tiling::window --warp west
  shift + alt - j : ${chunkc} tiling::window --warp south
  shift + alt - k : ${chunkc} tiling::window --warp north
  shift + alt - l : ${chunkc} tiling::window --warp east

  alt - r : ${chunkc} tiling::desktop --rotate 90

  # move focused container to workspace
  shift + alt - m : ${chunkc} tiling::window --send-to-desktop $(${chunkc} get _last_active_desktop)
  shift + alt - p : ${chunkc} tiling::window --send-to-desktop prev
  shift + alt - n : ${chunkc} tiling::window --send-to-desktop next
  shift + alt - 1 : ${chunkc} tiling::window --send-to-desktop 1
  shift + alt - 2 : ${chunkc} tiling::window --send-to-desktop 2
  shift + alt - 3 : ${chunkc} tiling::window --send-to-desktop 3
  shift + alt - 4 : ${chunkc} tiling::window --send-to-desktop 4
  shift + alt - 5 : ${chunkc} tiling::window --send-to-desktop 5
  shift + alt - 6 : ${chunkc} tiling::window --send-to-desktop 6

  # Resize windows
  shift + alt - a : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge west; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge east
  shift + alt - s : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge south; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge north
  shift + alt - w : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge north; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge south
  shift + alt - d : ${chunkc} tiling::window --use-temporary-ratio 0.05 --adjust-window-edge east; ${chunkc} tiling::window --use-temporary-ratio -0.05 --adjust-window-edge west
''
