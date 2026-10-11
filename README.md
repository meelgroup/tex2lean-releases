# Tex2Lean CLI

Tex2Lean turns mathematical results from a paper into a Lean 4 project. It reads
the paper, translates its mathematical model and pseudocode, and works on proofs
checked by Lean. It is designed primarily for papers about algorithms.

This repository provides CLI downloads, installation instructions, and the issue
tracker. **For the graphical VS Code extension and GUI instructions, visit
[tex2lean.com](https://tex2lean.com).**

## Install

On macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.sh | sh
```

On Windows, in PowerShell:

```powershell
irm https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.ps1 | iex
```

The installer downloads the executable for your platform and verifies it against
`checksums.txt` from the release. No separate Node installation is required.
On macOS and Linux, ensure `~/.local/bin` is on your `PATH`.

Check your installation:

```sh
tex2lean --version
tex2lean --help
```

For manual installation, download the executable for your platform from the
[latest release](https://github.com/meelgroup/tex2lean-releases/releases/latest)
and verify its SHA-256 against `checksums.txt`. The installer scripts are
available as [install.sh](install.sh) and [install.ps1](install.ps1).

## Requirements

- Git. Tex2Lean installs Lean, but does not install Git.
- A supported model connection: a signed-in Claude Code or Codex CLI, or an
  Anthropic, OpenAI, or OpenRouter API key.
- Disk space for Lean and its libraries. The initial Mathlib build can take
  time and requires several gigabytes.

The CLI runs on macOS, Linux, and Windows without an editor.

## Get started

Open a terminal in the folder containing your paper's `.tex` files:

```sh
cd /path/to/your/paper
tex2lean connect
tex2lean setup
tex2lean scan
tex2lean targets
```

`connect` configures your model connection. `setup` prepares the Lean environment.
`scan` reads the paper and lists its results; `targets` shows their identifiers
and status. LaTeX source gives the best results. PDF import is also available
when `pdftotext` or `mutool` is installed.

To work on a selected result, substitute its identifier for `t1`:

```sh
tex2lean plan t1
tex2lean prove t1
```

To plan and prove the remaining results in order:

```sh
tex2lean all
```

## Models and configuration

Use `tex2lean connect` to configure authentication. You can select a provider
and model on a command:

```sh
tex2lean prove t1 --provider codex-cli
tex2lean prove t1 --provider claude-cli
tex2lean prove t1 --provider openrouter --model <model-slug>
```

For OpenRouter, set `OPENROUTER_API_KEY` and choose a model that supports tool
calling. OpenRouter runs with local file and Lean tools and does not require
Claude Code or Codex to be installed.

Use `--project DIR` to work in another paper folder, and `--agents N` to set
worker concurrency. Run `tex2lean --help` for all options and supported providers.

## Pause, Resume, and check

During a run, press **p** to request a pause or **Ctrl+C** to stop. Resume saved
work with:

```sh
tex2lean resume t1
```

The CLI and the VS Code extension share project state. Only one Tex2Lean run can
work on a project at a time; pause the current run before switching between them.

Useful inspection commands:

| Command | Purpose |
| --- | --- |
| `tex2lean targets` | List results and their status. |
| `tex2lean show t1` | Locate a result in the paper. |
| `tex2lean lean t1` | Locate its Lean file and declaration. |
| `tex2lean check` | Check the development's build and proof obligations. |
| `tex2lean proved t1` | Inspect the assumptions behind a finished theorem. |
| `tex2lean handoff` | Compare the Lean development with the paper. |

## Interactive prompt

In an interactive terminal, commands can leave you at the `tex2lean>` prompt.
Use `/help` to list available commands, `/targets` to inspect results, `/log`
to inspect recent logs, and `/quit` to leave.

Text entered without a leading `/` becomes a note for the run. It is included
in later worker instructions at the next boundary.

## Upgrade

```sh
tex2lean upgrade
```

You can also rerun the installer to download the latest release.

## Report a problem

[Open an issue](https://github.com/meelgroup/tex2lean-releases/issues/new/choose)
and include the output of `tex2lean --version`, the command you ran, and the
relevant log excerpt. Use `/log` at the interactive prompt to find recent logs.
Review logs before posting and remove information you do not want to share
publicly.

Questions can also be sent to [meel@gatech.edu](mailto:meel@gatech.edu).

## Source and license

Tex2Lean's source is not currently public. This repository distributes release
artifacts and hosts the issue tracker. See [LICENSE](LICENSE) for usage terms.

Built at Georgia Tech.
