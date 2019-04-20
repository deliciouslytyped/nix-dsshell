#An example.
{pkgs ? import ./nixpkgs.nix {}}:
with { inherit (pkgs) lib; }; {
  pls = ''
    echo hi;
    '';
  }
