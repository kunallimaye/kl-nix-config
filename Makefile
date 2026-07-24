# Default configuration target to use if not overridden
FLAKE_TARGET ?= .\#mac

# Dynamically resolve the absolute path to the nix binary to bypass sudo PATH stripping
NIX_BIN := $(shell which nix 2>/dev/null || echo "/nix/var/nix/profiles/default/bin/nix")

.PHONY: all syntax-check rebuild-check rebuild-run update clean-cache help

# Default target when you just run 'make'
all: help

## syntax-check  : Evaluate expressions to catch formatting and variable typos instantly (No downloads)
syntax-check:
	@echo "🔍 Checking Nix syntax..."
	$(NIX_BIN) flake check

## rebuild-check : Dry-run the configuration to see what would change without applying it
rebuild-check: syntax-check
	@echo "⚙️ Dry-running system configuration evaluation..."
	sudo env PATH="$(dir $(NIX_BIN)):$$PATH" $(NIX_BIN) run nix-darwin#darwin-rebuild -- check --flake $(FLAKE_TARGET)

## rebuild-run   : Live deploy and switch over to your new environment configurations
rebuild-run:
	@echo "🚀 Activating live system configuration..."
	sudo env PATH="$(dir $(NIX_BIN)):$$PATH" $(NIX_BIN) run nix-darwin#darwin-rebuild -- switch --flake $(FLAKE_TARGET)

## update        : Fetch the newest revisions for your standard inputs lockfile
update:
	@echo "🔄 Updating flake repository lockfile indexes..."
	$(NIX_BIN) flake update

## clean-cache  : Collect garbage and remove old Nix store generations to free disk space
clean-cache:
	@echo "🧹 Cleaning unused Nix store paths and old generations..."
	$(dir $(NIX_BIN))nix-collect-garbage -d
	$(NIX_BIN) store optimise

## help          : Print available commands
help:
	@echo "Available commands in this Nix GNU Makefile:"
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':'

