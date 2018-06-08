{pkgs, shellcheck, stdenv, config, lib, ...}:

let
  i3blocksContrib = pkgs.callPackage ./i3blocksContrib {};
in ''
  # i3blocks config file
  #
  # List of valid properties:
  #
  # align
  # color
  # command
  # full_text
  # instance
  # interval
  # label
  # min_width
  # name
  # separator
  # separator_block_width
  # short_text
  # signal
  # urgent

  # Global properties
  #
  # The top properties below are applied to every block, but can be overridden.
  # Each block command defaults to the script name to avoid boilerplate.
  command=${pkgs.i3blocks}/libexec/i3blocks/$BLOCK_NAME
  separator_block_width=15
  markup=none

  # Next Appointment
  [calendar]
  command=~/${config.home.file."bin/i3blocks/calendar".target}
  interval=60

  # Pomodoro
  [pomodoro]
  command=~/${config.home.file."bin/i3blocks/pomodoro".target}
  interval=1

  # Bitcoin Price
  [btc]
  label=BTC
  command=~/${config.home.file."bin/i3blocks/bitcoin".target}
  interval=60

  # Ethereum Price
  [eth]
  label=ETH
  command=~/${config.home.file."bin/i3blocks/ethereum".target}
  interval=60

  # Volume indicator
  [volume]
  label=♪
  instance=Master
  interval=once
  signal=10

  # Media Player
  [mediaplayer]
  commad=${i3blocksContrib.mediaplayer}/mediaplayer
  instance=mpd
  interval=5
  signal=10
  separator=true

  # Google Play Music Desktop Player on VM Host
  [googlemusicdesktopplayer]
  command=~/${config.home.file."bin/i3blocks/googlemusicdesktopplayer".target}
  interval=5
  separator=true

  # Memory usage
  [memory]
  label=MEM
  separator=false
  interval=30

  [memory]
  label=SWAP
  instance=swap
  separator=false
  interval=30

  # Disk usage
  [disk]
  label=HOME
  interval=30

  # Network interface monitoring
  #
  [iface]
  color=#00FF00
  interval=10
  #separator=false

  [bandwidth]
  command=${i3blocksContrib.bandwidth}/bandwidth -i enp0s3

  # CPU usage
  [cpu_usage]
  label=CPU
  interval=10
  min_width=CPU: 100.00%
  #separator=false

  # Battery indicator
  [batterybar]
  command=${i3blocksContrib.batterybar}/batterybar
  label=⚡
  interval=30
  markup=pango
  min_width=bat: ■■■■■

  # Date Time
  #
  [time]
  command=date '+%a %b %d %l:%M:%S %P'
  interval=5

  # Generic media player support
  #
  # This displays "ARTIST - SONG" if a music is playing.
  # Supported players are: spotify, vlc, audacious, xmms2, mplayer, and others.
  #[mediaplayer]
  #instance=spotify
  #interval=5
  #signal=10

  # Temperature
  #
  # Support multiple chips, though lm-sensors.
  # The script may be called with -w and -c switches to specify thresholds,
  # see the script for details.
  [temperature]
  label=TEMP
  interval=10
''
