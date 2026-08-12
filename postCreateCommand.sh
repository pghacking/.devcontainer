#!/bin/bash

function configure_git_excludes {
  local devcontainer_dir repo_root exclude_file pattern

  devcontainer_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$(dirname -- "$devcontainer_dir")"
  exclude_file="$(git -C "$repo_root" rev-parse --path-format=absolute --git-path info/exclude)"

  for pattern in '/.vscode/' '/.devcontainer/'; do
    grep -qxF "$pattern" "$exclude_file" || printf '%s\n' "$pattern" >> "$exclude_file"
  done
}

function configure_vscode {
  ./.devcontainer/setup-vscode.sh

  if [ ! -f .vscode/c_cpp_properties.json ]; then
    cat <<EOL > ".vscode/c_cpp_properties.json"
{
    "configurations": [
        {
            "name": "Postgres Development Configuration",
            "includePath": [
                "\${workspaceFolder}/**",
                "\${workspaceFolder}/src/include/",
                "\${workspaceFolder}/Debug/src/include/"
            ]
        }
    ],
    "version": 4
}
EOL
  fi

  if [ ! -f .vscode/pgsql_hacker_helper.json ]; then
    cat <<EOL > ".vscode/pgsql_hacker_helper.json"
{
    "version": 3,
    "typedefs": "src/tools/pgindent/typedefs.list"
}
EOL
  fi
}

# https://wiki.postgresql.org/wiki/Getting_a_stack_trace_of_a_running_PostgreSQL_backend_on_Linux/BSD
function configure_coredumps {
  sudo sh -c "echo 'core.%p.sig%s.%ts' > /proc/sys/kernel/core_pattern"
}

function configure_perf {
  sudo sh -c "echo 0 > /proc/sys/kernel/kptr_restrict"
  sudo su -c "echo -1 > /proc/sys/kernel/perf_event_paranoid"

  if [ ! -d /opt/freedom/tools/FlameGraph ]; then
    git clone --depth 1 https://github.com/brendangregg/FlameGraph.git /opt/freedom/tools/FlameGraph
  fi
}

function configure_pg_plugins {
  if [ ! -d /opt/freedom/extensions/pg_plugins ]; then
    git clone --depth 1 https://github.com/michaelpq/pg_plugins.git /opt/freedom/extensions/pg_plugins
  fi
}

function main {
  configure_git_excludes
  configure_coredumps
  configure_vscode
  configure_perf
  configure_pg_plugins
}

main $@
