{
  description = "My Android project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    devshell,
    flake-utils,
  }:
    {
      pkgs = import nixpkgs { config = { }; overlays = [ ]; system = "x86_64-linux"; };
    } //
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
          overlays = [
            devshell.overlays.default
          ];
        };

        buildToolsVersion = "34.0.0"; # 17.0.0, 18.0.1, 18.1.0, 18.1.1, 19.0.0, 19.0.1, 19.0.2, 19.0.3, 19.1.0, 20.0.0, 21.0.0, 21.0.1, 21.0.2, 21.1.0, 21.1.1, 21.1.2, 22.0.0, 22.0.1, 23.0.0, 23.0.1, 23.0.2, 23.0.3, 24.0.0, 24.0.1, 24.0.2, 24.0.3, 25.0.0, 25.0.1, 25.0.2, 25.0.3, 26.0.0, 26.0.1, 26.0.2, 26.0.3, 27.0.0, 27.0.1, 27.0.2, 27.0.3, 28.0.0, 28.0.0-rc1, 28.0.0-rc2, 28.0.1, 28.0.2, 28.0.3, 29.0.0, 29.0.0-rc1, 29.0.0-rc2, 29.0.0-rc3, 29.0.1, 29.0.2, 29.0.3, 30.0.0, 30.0.1, 30.0.2, 30.0.3, 31.0.0, 32.0.0, 32.1.0-rc1, 33.0.0, 33.0.1, 33.0.2, 33.0.3, 34.0.0, 34.0.0-rc1, 34.0.0-rc2, 34.0.0-rc3, 34.0.0-rc4, 35.0.0-rc1, 35.0.0-rc2
        ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          platformToolsVersion = "35.0.1";
          buildToolsVersions = [ buildToolsVersion ];
          includeEmulator = true;
          platformVersions = [ "34" ];
          includeSystemImages = true;
          systemImageTypes = [ "google_apis_playstore" ];
          abiVersions = [ "x86_64" ];
          includeNDK = true;
          useGoogleAPIs = true;
          includeExtras = [ "extras;google;gcm" ];
        };
        myandroid-studio = pkgs.android-studio.withSdk androidComposition.androidsdk;
      in
      {
        devShell = pkgs.devshell.mkShell rec {
          name = "android-project";
          env = with pkgs; [
            { name = "ANDROID_HOME"; value = ANDROID_HOME; }
            { name = "ANDROID_SDK_ROOT"; value = ANDROID_HOME;}
            { name = "GRADLE_OPTS"; value = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2";}
            { name = "JAVA_HOME"; value = jdk.home; }
            { name = "NATIVESCRIPT_ANDROID_STUDIO_PATH"; eval = "$(which android-studio)"; }
            { name = "PATH"; prefix = "/home/srghma/projects/nativescript-cli/bin/"; }
          ];
          packages = with pkgs; [
            arion
            gradle
            jdk
            nodejs_22
            nodePackages.pnpm
            androidComposition.androidsdk
            myandroid-studio
          ];
        };
      }
    );
}

# f = builtins.getFlake "/home/srghma/projects/docker-nativescript"
# pkgs = import f.inputs.nixpkgs {
#   inherit system;
#   config.allowUnfree = true;
# }

# avdmanager create avd -n myEmulatorFromNixpkgs -k "system-images;android-34-ext10;google_apis_playstore;x86_64"
# emulator -avd myEmulatorFromNixpkgs
