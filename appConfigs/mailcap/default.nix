{ pkgs, ...}:

pkgs.writeText "mailcap" ''
  # Example mailcap file for Reddit Terminal Viewer
  # https://github.com/michael-lazar/rtv/
  #
  # Copy the contents of this file to {HOME}/.mailcap, or point to using $MAILCAPS
  # Then launch RTV using the --enable-media flag. All shell commands defined in
  # this file depend on external programs that must be installed on your system.
  #
  # HELP REQUESTED! If you come up with your own commands (especially for OS X)
  # and would like to share, please post an issue on the GitHub tracker and we
  # can get them added to this file as references.
  #
  #
  #                              Mailcap 101
  # - The first entry with a matching MIME type will be executed, * is a wildcard
  # - %s will be replaced with the image or video url
  # - Add ``test=test -n "$DISPLAY"`` if your command opens a new window
  # - Add ``needstermial`` for commands that use the terminal
  # - Add ``copiousoutput`` for commands that dump text to stdout

  ###############################################################################
  # Commands below this point will open media in a separate window without
  # pausing execution of RTV.
  ###############################################################################

  # auto view using w3m
  text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;

  # Feh is a simple and effective image viewer
  # Note that rtv returns a list of urls for imgur albums, so we don't put quotes
  # around the `%s`
  image/x-imgur-album; ${pkgs.feh}/bin/feh -g 640x480 %s; test=test -n "$DISPLAY"
  image/*; ${pkgs.feh}/bin/feh -g 640x480 '%s'; test=test -n "$DISPLAY"

  # Youtube videos are assigned a custom mime-type, which can be streamed with
  # vlc or youtube-dl.
  video/x-youtube; ${pkgs.vlc}/bin/vlc '%s' --width 640 --height 480; test=test -n "$DISPLAY"
  video/x-youtube; ${pkgs.youtube-dl}/bin/youtube-dl -q -o - '%s' | ${pkgs.mpv}/bin/mpv - --autofit 640x480; test=test -n "$DISPLAY"

  # Mpv is a simple and effective video streamer
  video/webm; ${pkgs.mpv}/bin/mpv '%s' --autofit 640x480 --loop=inf; test=test -n "$DISPLAY"
  video/*; ${pkgs.mpv}/bin/mpv '%s' --autofit 640x480 --loop=inf; test=test -n "$DISPLAY"

  ###############################################################################
  # Commands below this point will attempt to display media directly in the
  # terminal when X is not available.
  ###############################################################################

  # Don't have a solution for albums yet
  image/x-imgur-album; echo

  # Display images in classic ascii using img2txt and lib-caca
  image/*; ${pkgs.curl}/bin/curl -s '%s' | ${pkgs.imagemagick}/bin/convert - jpg:/tmp/rtv.jpg && img2txt -f utf8 /tmp/rtv.jpg; needsterminal; copiousoutput

  # Ascii videos
  video/x-youtube; ${pkgs.youtube-dl}/bin/youtube-dl -q -o - '%s' | ${pkgs.mplayer}/bin/mplayer -cache 8192 -vo caca -quiet -; needsterminal
  video/*; ${pkgs.wget}/bin/wget '%s' -O - | ${pkgs.mplayer}/bin/mplayer -cache 8192 -vo caca -quiet -; needsterminal
''
