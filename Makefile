update:
	nix flake update

upgrade:
	nixos-rebuild switch

debug:
	nixos-rebuild switch --show-trace --verbose

history:
	profile history --profile /nix/var/nix/profiles/system

gc:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

	sudo nix store gc --debug
