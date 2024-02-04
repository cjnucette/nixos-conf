{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nix-index-database,
    ...
  }: {
    nixosConfigurations = {
      beta = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          # (args: { nixpkgs.overlays = import ./overlays args; })

          ./configuration.nix
          ./hosts/beta

          nix-index-database.nixosModules.nix-index
        ];
      };
    };
  };
}
