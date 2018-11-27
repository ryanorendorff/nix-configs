{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
    name = "postman-${version}";
    version = "6.5.2";

    src = fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/linux64";
      sha1 = "nxws82vgrli1pf23ndnzay265j9xry5s";
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
        atk
        alsaLib
        cairo
        cups
        dbus_daemon.lib
        expat
        gdk_pixbuf
        glib
        gtk2-x11
        freetype
        fontconfig
        nss
        nspr
        udev.lib
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
  }