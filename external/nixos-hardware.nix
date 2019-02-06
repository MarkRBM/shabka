{ fetchpatch, runCommand }:

let
  pinnedVersion = builtins.fromJSON (builtins.readFile ./nixos-hardware-version.json);
  pinned = builtins.fetchTarball {
    inherit (pinnedVersion) url sha256;
  };

  patches = [
    # Dell XPS 9380 hardware profile
    # https://github.com/NixOS/nixos-hardware/pull/97
    (fetchpatch {
      url = "https://github.com/NixOS/nixos-hardware/pull/97.patch";
      sha256 = "1pryw8kwk8h99ag08wni6gmkyrpabgyzm55lf8b6zd25ph4027m5";
    })
  ];

  patched = runCommand "nixos-hardware-${pinnedVersion.rev}"
    {
      inherit pinned patches;

      preferLocalBuild = true;
    }
    ''
      cp -r $pinned $out
      chmod -R +w $out
      for p in $patches; do
        echo "Applying patch $p";
        patch -d $out -p1 < "$p";
      done
    '';

in
  patched
