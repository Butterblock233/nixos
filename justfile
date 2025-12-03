
format:
	nixfmt ./*.nix

wsl:
	sudo nixos-rebuild switch --flake .#wsl --impure

wsl-trace:
	sudo nixos-rebuild switch --flake .#wsl --impure --show-trace
cleanup:
	# 清理 7 天之前的所有历史版本
	sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
	# 清理历史版本并不会删除数据，还需要以 root 身份运行 gc 命令来删除所有未使用的包
	sudo nix-collect-garbage --delete-old

	# 因为如下 issue，还需要以当前用户身份运行 gc 命令来删除 home-manager 的历史版本和包
	# https://github.com/NixOS/nix/issues/8508
	nix-collect-garbage --delete-old
