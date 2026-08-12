#!/usr/bin/env bash

set -euo pipefail

devcontainer_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(dirname -- "$devcontainer_dir")"
vscode_dir="$repo_root/.vscode"

mkdir -p "$vscode_dir"

link_vscode_config() {
  local name="$1"
  local source="$devcontainer_dir/$name"
  local relative_source="../.devcontainer/$name"
  local target="$vscode_dir/$name"
  local backup="${target}.pre-devcontainer"

  if [ ! -f "$source" ]; then
    echo "Missing VS Code configuration: $source" >&2
    return 1
  fi

  if [ -L "$target" ]; then
    ln -sfn "$relative_source" "$target"
    echo "Updated $target -> $relative_source"
    return
  fi

  if [ -e "$target" ]; then
    if [ -e "$backup" ] || [ -L "$backup" ]; then
      echo "Cannot replace $target because backup already exists: $backup" >&2
      return 1
    fi

    mv "$target" "$backup"
    echo "Backed up $target to $backup"
  fi

  ln -s "$relative_source" "$target"
  echo "Linked $target -> $relative_source"
}

link_vscode_config tasks.json
link_vscode_config launch.json
