{ pkgs, lib, config, inputs, ... }:

let
  libs = [
    pkgs.libGL
    pkgs.glib
    pkgs.nspr
    pkgs.nss
    pkgs.atk
    pkgs.cups
    pkgs.dbus
    pkgs.cairo
    pkgs.gtk3
    pkgs.pango
    pkgs.expat
    pkgs.libxcb
    pkgs.libxkbcommon
    pkgs.alsa-lib
    pkgs.libgbm
    pkgs.libdrm
    pkgs.pkg-config
    pkgs.stdenv.cc.cc

    pkgs.libx11
    pkgs.libxtst
    pkgs.libxi
    pkgs.libxinerama
    pkgs.libxrandr
    pkgs.libxext
    pkgs.libxcomposite
    pkgs.libxdamage
    pkgs.libxfixes
    pkgs.xorgproto
  ];
in
{
  packages = [
    pkgs.git
    pkgs.vscode
    pkgs.python3
  ] ++ libs;

  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath (libs ++ [ pkgs.stdenv.cc.cc.lib ]);
    CPATH = lib.makeSearchPathOutput "dev" "include" [
      pkgs.stdenv.cc.libc
      pkgs.xorgproto
      pkgs.libx11
      pkgs.libxtst
      pkgs.libxi
      pkgs.libxinerama
      pkgs.libxrandr
      pkgs.libxext
    ];
    LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.libc
      pkgs.libx11
      pkgs.libxtst
      pkgs.libxi
      pkgs.libxinerama
      pkgs.libxrandr
      pkgs.libxext
    ];
    CFLAGS = "-D_GNU_SOURCE -Wno-implicit-function-declaration -Wno-error=implicit-function-declaration";
    CPPFLAGS = "-D_GNU_SOURCE -Wno-implicit-function-declaration -Wno-error=implicit-function-declaration";
    CXXFLAGS = "-D_GNU_SOURCE";
    NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE -Wno-implicit-function-declaration -Wno-error=implicit-function-declaration";
  };

  languages = {
    javascript = {
      enable = true;
      package = pkgs.nodejs_24;
      corepack.enable = true;
      yarn.enable = true;
    };
    typescript.enable = true;
  };
}
