# Unofficial devcontainer config for Postgres

## Usage

```
cd <your postgres git repo>
git clone --depth 1 https://github.com/pghacking/.devcontainer.git
code .
```

If `code` doesn't work, please reference https://code.visualstudio.com/docs/setup/mac.

Open the **Command Palette** by typing `Cmd`+`Shift`+`P`(Mac)/`Ctrl`+`Shift`+`P`(Windows/Linux) and select `Dev Containers: Rebuild and Reopen in Container`.

You are all set.

**Caveat**

I'm using directories from my personal favorites. If you want to use different ones, please ensure they are consistent across launch.json, tasks.json, and the Dockerfile.

If you want to add more personal configurations(e.g. git alias), you can use a devcontainer dotfile repository.

See: [Personalizing with dotfile repositories](https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories)
