#!/bin/bash

function configure_vscode {
  if [ ! -d .vscode ]; then
    mkdir .vscode
    cat <<EOL > ".vscode/c_cpp_properties.json"
{
    "configurations": [
        {
            "name": "Postgres Development Configuration",
            "includePath": [
                "\${workspaceFolder}/**",
                "\${workspaceFolder}/src/include/",
                "\${workspaceFolder}/../build/src/include/"
            ],
            "cStandard": "c99",
            "configurationProvider": "ms-vscode.makefile-tools"
        }
    ],
    "version": 4
}
EOL
    cp .devcontainer/launch.json .vscode/
    cp .devcontainer/tasks.json .vscode/
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
  configure_coredumps
  configure_git
  configure_vscode
  configure_perf
  configure_pg_plugins
}

main $@
