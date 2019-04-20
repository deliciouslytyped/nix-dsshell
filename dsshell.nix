{pkgs ? import ./nixpkgs.nix, shellFuncs ? import ./funcs.nix {}}:
with { inherit (pkgs) lib stdenv bashInteractive; }; #TODO other shells?
let
  projRelPath = builtins.unsafeDiscardStringContext (builtins.toString ./.);
  shellNix = lib.concatStrings [ projRelPath "/dsshell.nix" ];

  funcsToStringList = s: lib.mapAttrsToList (name: val: ''
    ${name} () {
      ${val}
    }
    '') s; #TODO this doesnt seem too good
in
  stdenv.mkDerivation { #TODO just be a lib function that returns a shellhook instead of a derivation?
    name = "dsshell";
    shellHook = ''
      ${lib.concatStringsSep "\n\n" (funcsToStringList shellFuncs)}

      reloadShell () { #TODO some kind of shell variable so you can reload a user specified file containing the current scripts or whatever
        exec nix-shell ${shellNix}
        }
      '';
    }
