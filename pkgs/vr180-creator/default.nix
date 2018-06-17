{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
    name = "vr180-creator-${version}";
    version = "1.0.0";

    src = fetchurl {
      url = "https://storage.googleapis.com/vr180-creator/download/VR180_Creator_linux_${version}.tar.gz";
      sha1 = "5761qi32mxvligd364y6vkqh3cc64lza";
      name = "${name}.tar.gz";
    };

    nativeBuildInputs = [ makeWrapper ];

    dontPatchELF = true;

    buildPhase = ":";   # nothing to build

    desktopItem = makeDesktopItem {
      name = "vr180-creator";
      exec = "vr180-creator";
      icon = "$out/share/vr180-creator/images/vr180.png";
      comment = "VR180 Editing Tool";
      desktopName = "VR180 Creator";
      genericName = "VR180 Creator";
      categories = "Application;Development;Video;";
    };

    installPhase = ''
      mkdir -p $out/bin $out/share/applications $out/share/vr180-creator
      cp -a ./* $out/share/vr180-creator/
      ln -s "$out/share/vr180-creator/VR180 Creator" $out/bin/vr180-creator
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
        --set-rpath "${libPath}:$out/share/vr180-creator" \
        "$out/share/vr180-creator/VR180 Creator"
      patchelf --set-rpath "${libPath}" $out/share/vr180-creator/libnode.so
      patchelf --set-rpath "${libPath}" $out/share/vr180-creator/libffmpeg.so
      wrapProgram "$out/share/vr180-creator/VR180 Creator" --prefix LD_LIBRARY_PATH : ${libPath}
    '';

    meta = with stdenv.lib; {
      homepage = https://vr.google.com/vr180/apps/;
      description = "Convert your VR180 footage into a standardized format so you can edit it with leading editing tools like Adobe Premiere and then re-inject the appropriate metadata for publishing.t";
      license = { free = false; };
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ xurei ];
    };
  }