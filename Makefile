update:
	nix flake update

upgrade:
	sudo nixos-rebuild switch --flake .

debug:
	sudo nixos-rebuild switch --flake . --show-trace --verbose

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

	sudo nix store gc --debug
