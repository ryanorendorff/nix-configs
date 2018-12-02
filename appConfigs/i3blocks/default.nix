{pkgs, lib, ...}:

pkgs.writeText "config" ''
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
  command=${pkgs.mine.i3blocks.mine.calendar}
  interval=60

  # Pomodoro
  [pomodoro]
  command=${pkgs.mine.i3blocks.mine.pomodoro}
  interval=1

  # Google Drive
  [google_drive]
  command=${pkgs.mine.i3blocks.mine.google_drive}
  interval=1

  # Bitcoin Price
  [btc]
  label=BTC
  command=${pkgs.mine.i3blocks.mine.bitcoin}
  interval=60

  # Ethereum Price
  [eth]
  label=ETH
  command=${pkgs.mine.i3blocks.mine.ethereum}
  interval=60

  # Volume indicator
  [volume]
  label=♪
  #MIXER=pulse
  instance=Master
  interval=once
  signal=10

  # Media Player
  [mediaplayer]
  command=${pkgs.mine.i3blocks.i3blocksContrib.mediaplayer}/mediaplayer
  instance=mpd
  interval=5
  signal=10
  separator=true

  # Google Play Music Desktop Player on VM Host
  [googlemusicdesktopplayer]
  command=${pkgs.mine.i3blocks.mine.googlemusicdesktopplayer}
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
  command=${pkgs.mine.i3blocks.i3blocksContrib.bandwidth}/bandwidth -i enp0s3

  # CPU usage
  [cpu_usage]
  label=CPU
  interval=10
  min_width=CPU: 100.00%
  #separator=false

  # Battery indicator
  [batterybar]
  command=${pkgs.mine.i3blocks.i3blocksContrib.batterybar}/batterybar
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
