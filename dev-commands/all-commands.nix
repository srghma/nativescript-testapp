{pkgs}: let
  exportEnvsCommand = attrs: builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${builtins.toString v}") attrs));

  # exportEnvsCommand = attrs:
  #   builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: let
  #     tracedName = pkgs.lib.traceValSeq name;
  #     tracedValue = pkgs.lib.traceValSeq value;
  #   in
  #     "export " + tracedName + "=" + tracedValue)
  #   attrs);

  # # type Name = String
  # # type Code = String
  # # Map Name Code -> List { name = String command = String }
  # to numtide/devshel
  mkScripts = attrsetOfNamesAndCode: builtins.attrValues (builtins.mapAttrs (name: command: {inherit name command;}) attrsetOfNamesAndCode);

  mkCommand = environment: content: ''
    ${exportEnvsCommand environment}
    ${content}
  '';
in
  mkScripts (
    import ./dev/default.nix {
      inherit mkCommand;
      inherit (pkgs) chromium rootProjectDir;
    }
  )
