# Unofficial Dev Container for PostgreSQL

## Usage

Clone this repository into a PostgreSQL source tree:

```bash
cd <postgres-repository>
git clone --depth 1 https://github.com/pghacking/.devcontainer.git
```

## Local development

Install the VS Code configuration links once, then open PostgreSQL:

```bash
./.devcontainer/setup-vscode.sh
code .
```

Meson, Ninja, PostgreSQL build dependencies, and task-specific tools must be
installed on the host.

## Dev Container

Open the PostgreSQL repository in VS Code, press `Cmd`+`Shift`+`P` on macOS or
`Ctrl`+`Shift`+`P` on Linux, then select
`Dev Containers: Rebuild and Reopen in Container`.

You are all set.

**Caveat**

With host networking, PostgreSQL listens directly on the host's port 5433.

If you want to add more personal configurations(e.g. git alias), you can use a devcontainer dotfile repository.

See: [Personalizing with dotfile repositories](https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories)
