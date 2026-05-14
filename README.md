# setup-ubi

A GitHub composite action that installs the [`ubi`](https://github.com/houseabsolute/ubi)
CLI and optionally uses it to install other release-binary tools.

## Usage

### Install ubi only

```yaml
- uses: mdgreenwald/setup-ubi@v0
- run: ubi --project BurntSushi/ripgrep --exe rg
```

### Install a single tool

```yaml
- uses: mdgreenwald/setup-ubi@v0
  with:
    project: houseabsolute/precious
- run: precious --version
```

### Bulk install

```yaml
- uses: mdgreenwald/setup-ubi@v0
  with:
    tools: |
      --project houseabsolute/precious
      --project BurntSushi/ripgrep --exe rg
      # comments and blank lines are ignored
```

Each line in `tools:` is passed verbatim as arguments to `ubi`, so any flag
`ubi` understands works.

> No tagged release exists yet. Until one is cut, pin to a SHA or `@main`.

## Inputs

| Input              | Default               | Description                                                                      |
| ------------------ | --------------------- | -------------------------------------------------------------------------------- |
| `version`          | `latest`              | ubi version to install (e.g. `v0.9.0`).                                          |
| `install-dir`      | `$HOME/.ubi/bin`      | Where ubi itself is installed; appended to `$GITHUB_PATH`.                       |
| `skip-install-ubi` | `false`               | If `true` and ubi is already on `PATH`, skip installing.                         |
| `github-token`     | `${{ github.token }}` | Forwarded as `GITHUB_TOKEN` to all ubi invocations.                              |
| `gitlab-token`     | `""`                  | Forwarded as `GITLAB_TOKEN` if set.                                              |
| `codeberg-token`   | `""`                  | Forwarded as `CODEBERG_TOKEN` if set.                                            |
| `project`          | `""`                  | Single-tool shorthand (e.g. `houseabsolute/precious`).                           |
| `tag`              | `""`                  | `--tag` for the single-tool case.                                                |
| `exe`              | `""`                  | `--exe` for the single-tool case.                                                |
| `matching`         | `""`                  | `--matching` for the single-tool case.                                           |
| `in`               | `$HOME/.local/bin`    | `--in` for both single-tool and any `tools` line that doesn't override it.       |
| `tools`            | `""`                  | Multi-line bulk install. Each non-empty, non-`#` line is passed verbatim to ubi. |
| `add-to-path`      | `true`                | Append the `in` directory to `$GITHUB_PATH` so installed tools are usable.       |

## Outputs

| Output     | Description                                |
| ---------- | ------------------------------------------ |
| `ubi-path` | Absolute path to the installed ubi binary. |

## Platform support

Tested on `ubuntu-latest`, `macos-latest`, and `windows-latest` for each release.
