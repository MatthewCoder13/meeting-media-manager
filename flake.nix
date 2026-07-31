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

      package = pkgs.appimageTools.wrapType2 {
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
