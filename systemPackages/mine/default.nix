{ pkgs, lib, xorg, gnome2, gnome3, makeWrapper, fetchurl, stdenv, fetchFromGitHub, pythonPackages, python36Packages, makeDesktopItem, ... }:

let
  pync_no_test = pkgs.python27.pkgs.buildPythonPackage rec {
    version  = "2.0.3";
    baseName = "pync";
    name     = "${baseName}-${version}";
    disabled = ! stdenv.isDarwin;

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/${baseName}/${name}.tar.gz";
      sha256 = "0zqim86gzlg80gx7fzzzyimg7656brgkqxx52691y5m36lbydf9q";
    };

    buildInputs = [ pkgs.coreutils pkgs.terminal-notifier ];

    propagatedBuildInputs = [ pkgs.python27.pkgs.dateutil ];

    patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
      sed -i 's|/usr/local/bin/|${pkgs.terminal-notifier}/bin/|g' pync/TerminalNotifier.py
    '';

    meta = {
      description = "Python Wrapper for Mac OS 10.8 Notification Center";
      homepage    = https://pypi.python.org/pypi/pync/1.4;
    };
  };
  weechatPythonPackageList = python: python.withPackages(ps: with ps; [
    websocket_client
    xmpppy
  ] ++ (if stdenv.isDarwin then [
    pync_no_test
  ] else []));
in let
  wee-slack = with pkgs; stdenv.mkDerivation rec {
    version = "2.0.0";
    baseName = "wee-slack";
    name = "${baseName}-${version}";

    src = fetchFromGitHub {
      rev = "v${version}";
      owner = baseName;
      repo = baseName;
      sha256 = "0712zzscgylprnnpgy2vr35a5mdqhic8kag5v3skhd84awbvk1n5";
    };


    buildInputs = [ weechat (weechatPythonPackageList python) ];
    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/share
      cp $src/wee_slack.py $out/share/
    '';

    meta = with stdenv.lib; {
      description = "A rofi emoji picker";
      maintainers = with maintainers; [ nocoolnametom ];
      license = licenses.mit;
    };
  };

  postman = stdenv.mkDerivation rec {
    name = "postman-${version}";
    version = "6.1.2";

    src = fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/linux64";
      sha1 = "06v99w0d4cphl03q3ii4zkwh8fayli52";
      name = "${name}.tar.gz";
    };

    nativeBuildInputs = [ makeWrapper ];

    dontPatchELF = true;

    buildPhase = ":";   # nothing to build

    desktopItem = makeDesktopItem {
      name = "postman";
      exec = "postman";
      icon = "$out/share/postman/resources/app/assets/icon.png";
      comment = "API Development Environment";
      desktopName = "Postman";
      genericName = "Postman";
      categories = "Application;Development;";
    };

    installPhase = ''
      mkdir -p $out/share/postman
      mkdir -p $out/share/applications
      cp -R app/* $out/share/postman
      mkdir -p $out/bin
      ln -s $out/share/postman/Postman $out/bin/postman
      ln -s ${desktopItem}/share/applications/* $out/share/applications/
    '';

    preFixup = let
      libPath = lib.makeLibraryPath [
        stdenv.cc.cc.lib
        gnome2.pango
        gnome2.GConf
        pkgs.atk
        pkgs.alsaLib
        pkgs.cairo
        pkgs.cups
        pkgs.dbus_daemon.lib
        pkgs.expat
        pkgs.gdk_pixbuf
        pkgs.glib
        pkgs.gtk2-x11
        pkgs.freetype
        pkgs.fontconfig
        pkgs.nss
        pkgs.nspr
        pkgs.udev.lib
        xorg.libX11
        xorg.libxcb
        xorg.libXi
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXrandr
        xorg.libXcomposite
        xorg.libXext
        xorg.libXfixes
        xorg.libXrender
        xorg.libX11
        xorg.libXtst
        xorg.libXScrnSaver
      ];
    in ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}:$out/share/postman" \
        $out/share/postman/Postman
      patchelf --set-rpath "${libPath}" $out/share/postman/libnode.so
      patchelf --set-rpath "${libPath}" $out/share/postman/libffmpeg.so
      wrapProgram $out/share/postman/Postman --prefix LD_LIBRARY_PATH : ${libPath}
    '';

    meta = with stdenv.lib; {
      homepage = https://www.getpostman.com;
      description = "API Development Environment";
      license = stdenv.lib.licenses.postman;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ xurei ];
    };
  };

  i3-gnome-pomodoro = with python36Packages; stdenv.mkDerivation rec {
    version = "1.0-alpha1";
    name = "i3-gnome-pomodoro-${version}";

    src = fetchFromGitHub {
      owner = "kantord";
      repo = "i3-gnome-pomodoro";
      rev = "7e654f695c92f04b840720b9fd13ea1c874bcafa";
      sha256 = "08100lfli2qxjsl3gsjx6q35488sbisb1xszarxvi0r1dd5v1px3";
    };

    unpackPhase = "true";

    buildInputs = [
      makeWrapper
      python
      pydbus
      click
      i3ipc
      pkgs.gnome3.pomodoro
    ];

    propagatedBuildInputs = [
      python
      pydbus
      click
      i3ipc
      pkgs.gnome3.pomodoro
    ];
    
    installPhase = ''
      mkdir -p $out/bin
      cp ${src}/pomodoro-client.py $out/bin/pomodoro-client
      wrapProgram $out/bin/pomodoro-client --prefix PYTHONPATH : "$PYTHONPATH"
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/kantord/i3-gnome-pomodoro;
      description = "Integrate gnome-pomodoro into i3";
      license = licenses.gpl3;
      maintainers = with maintainers; [ nocoolnametom ];
    };
  };
in {
  wee-slack = wee-slack;
  postman-mine = postman;
  i3-gnome-pomodoro-mine = i3-gnome-pomodoro;
  weechat-with-slack = pkgs.weechat.override {
    extraBuildInputs = [
      wee-slack
      pkgs.perl
      pkgs.aspellDicts.en
    ];
    configure = {availablePlugins,...}: {
      plugins =
        with availablePlugins; [
          perl
          (weechatPythonPackageList python)
        ];
    };
  };
}
