update:
	nix flake update

build:
	sudo nixos-rebuild switch --flake .

debug:
	sudo nixos-rebuild switch --flake . --show-trace --verbose

history:
	nix profile history --profile /nix/var/nix/profiles/system

clean:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
	sudo nix store gc --debug
