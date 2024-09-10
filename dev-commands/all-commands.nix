{ pkgs }:

let

config = rec {
  # type Name = String
  # type Code = String
  # Map Name Code -> List Pkg
  mkScripts = attrsetOfNamesAndCode: pkgs.lib.attrValues (pkgs.lib.mapAttrs (name: code: pkgs.writeShellScriptBin name code) attrsetOfNamesAndCode);

  mkCommand = environment: content: ''
    set -eux

    ${pkgs.mylib.exportEnvsCommand environment}

    ${content}
  '';
};

in

builtins.concatLists [
  (import ./dev/default.nix { inherit pkgs config; })
]
