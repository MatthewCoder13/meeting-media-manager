{
  description = "Meeting Media Manager (M³) — a cross-platform app to download and present media for congregation meetings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      version = "26.7.8";

      appimage = pkgs.fetchurl {
        url = "https://github.com/sircharlo/meeting-media-manager/releases/download/v${version}/meeting-media-manager-${version}-x86_64.AppImage";
        hash = "sha256-3ElNudFrY5oPbg3JuQv0ngyaDkNdSNfe0r/LL8yZ6JU=";
      };

      wrapper = pkgs.appimageTools.wrapType2 {
        pname = "meeting-media-manager";
        inherit version;
        src = appimage;
        meta = {
          description = "Cross-platform app to download and present media for congregation meetings of Jehovah's Witnesses";
          homepage = "https://sircharlo.github.io/meeting-media-manager/";
          license = pkgs.lib.licenses.agpl3Plus;
          platforms = [ "x86_64-linux" ];
          maintainers = [ ];
        };
      };

      extracted = pkgs.appimageTools.extractType2 {
        pname = "meeting-media-manager";
        inherit version;
        src = appimage;
      };

      desktopItem = pkgs.makeDesktopItem {
        name = "meeting-media-manager";
        desktopName = "Meeting Media Manager";
        comment = "A cross-platform app to download and present media for congregation meetings of Jehovah's Witnesses";
        icon = "meeting-media-manager";
        exec = "${wrapper}/bin/meeting-media-manager %U";
        terminal = false;
        categories = [ "Utility" ];
        startupNotify = false;
        startupWMClass = "Meeting Media Manager";
      };

      package = pkgs.symlinkJoin {
        name = "meeting-media-manager-${version}";
        paths = [ wrapper desktopItem ];
        postBuild = ''
          install -Dm644 "${extracted}/usr/share/icons/hicolor/512x512/apps/meeting-media-manager.png" "$out/share/icons/hicolor/512x512/apps/meeting-media-manager.png"
        '';
        meta = wrapper.meta;
      };
    in
    {
      packages.${system} = {
        meeting-media-manager = package;
        default = package;
      };

      apps.${system} = {
        default = {
          type = "app";
          program = "${package}/bin/meeting-media-manager";
        };
      };

      overlays.default = final: prev: { meeting-media-manager = package; };
    };
}
