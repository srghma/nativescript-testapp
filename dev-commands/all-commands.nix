{pkgs}: let
  exportEnvsCommand = attrs: builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: "export " + name + "=" + builtins.toString value) attrs);

  # # type Name = String
  # # type Code = String
  # # Map Name Code -> List { name = String command = String }
  # to numtide/devshel
  mkScripts = attrsetOfNamesAndCode: pkgs.lib.attrValues (pkgs.lib.mapAttrs (name: command: {inherit name command;}) attrsetOfNamesAndCode);

  mkCommand = environment: content: content;
  # ''
  #   set -eux
  #
  #   ${exportEnvsCommand environment}
  #
  #   ${content}
  # '';
in
  mkScripts (
    import ./dev/default.nix {
      inherit mkCommand;
      inherit (pkgs) chromium rootProjectDir;
    }
  )
