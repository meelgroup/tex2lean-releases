# Tex2Lean

**From a theorem in your paper to a working Lean 4 project.**

> Alpha. Expect bugs. Please report them — see [Reporting a bug](#reporting-a-bug).

You have an algorithm and a theorem about it. Tex2Lean formalizes both. The
pseudocode is transcribed line by line from your paper. The theorem is stated
over what that pseudocode returns. Then it proves the theorem.

It handles other kinds of paper too. Algorithms are what it is tuned for.

This repository is where you download the extension and report problems. The
source is not here — see [Source](#source).

There are two ways to run it. The **VS Code extension** puts it in a side bar
next to your paper. The **`tex2lean` command** is the same program in a
terminal, for a machine you reach over ssh, an overnight run, or CI. Install
either, or both.

## Install the extension

1. Download `tex2lean4.vsix` from the
   [latest release](https://github.com/meelgroup/tex2lean-releases/releases/latest).
2. In VS Code: **Extensions** → the `···` menu → **Install from VSIX…**. Pick
   the file.

Or from a terminal:

```sh
code --install-extension tex2lean4.vsix
```

To upgrade, install the newer file over the top. VS Code replaces the old one.

The version shown in the Extensions pane is what you are running. When something
behaves oddly, check it against the latest release first.

## Install the command line

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.sh | sh
```

Windows, in PowerShell:

```powershell
irm https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.ps1 | iex
```

Then, in the folder that holds your paper:

```sh
tex2lean scan
tex2lean all
```

`tex2lean --help` lists every command.

**What the installer does.** It downloads one file for your platform from the
latest release, checks it against the published SHA-256, and puts it in
`~/.local/bin`. It does not need Node, Python or a package manager, and it does
not ask for a password. It does not edit your shell profile: if `~/.local/bin`
is not on your `PATH` it prints the line to add and leaves that to you. On
Windows it adds one directory to your user `PATH` and says so.

The script is [install.sh](install.sh) in this repository. Read it before you
pipe it into a shell — it is about a hundred lines, and that is why it lives
here rather than being hidden inside a download.

Prefer to do it by hand? Download `tex2lean-<your platform>.gz` from the
[latest release](https://github.com/meelgroup/tex2lean-releases/releases/latest),
check it against `checksums.txt`, `gunzip` it, `chmod +x` it, and put it
somewhere on your `PATH`.

- **Upgrade:** run the same line again.
- **Uninstall:** `rm ~/.local/bin/tex2lean`. Nothing else was added.
- **A specific release:** `TEX2LEAN_VERSION=v0.2.0` before the command.
- **Somewhere else:** `TEX2LEAN_INSTALL_DIR=/opt/bin`.

The extension and the command line are the same program and read the same
project. They will not run on the same paper at once — whichever starts second
is told what holds it.

## What you need

- **VS Code 1.90 or newer**, for the extension. The command line needs no
  editor and no runtime; it is one self-contained file.
- **git.** Tex2Lean installs Lean for you. It does not install git. Use your
  system's package manager for that.
- **A model to drive it.** One of:
  - a **Claude** Pro or Max subscription, with [Claude Code](https://claude.com/download) signed in;
  - a **ChatGPT** Plus or Pro subscription, with [Codex](https://openai.com/codex) signed in;
  - an [Anthropic](https://console.anthropic.com/) or [OpenAI](https://platform.openai.com/) API key.

The first run builds Mathlib. That happens once per machine. Set aside an hour
and 15 GB of disk.

## Getting started

Open the side bar. Run **Tex2Lean: Open in Side bar** from the command palette.

1. **Connect to Claude or ChatGPT.** Pick your subscription, or paste an API key.
2. **Scan LaTeX sources.** Your paper's main results appear in the side bar.
   Everything else the scan found is one click behind them.
3. **Pick a result and click Formalize.** Or use **Formalize several…** to tick
   off a batch and let it work through them.

Each row has its own buttons:

| Button | What it does |
| --- | --- |
| **.tex** | Opens the statement in your paper, at the line it was read from. |
| **.lean** | Opens the Lean file it was formalized into. Appears once there is one. |
| **Formalize** | Starts the run for that one statement. |
| **Recheck** | Asks Lean about a finished statement again. |

**Recheck** is worth knowing about. It rebuilds the statement and reads its
axioms. If the only axioms are Lean's own three, it says so and stops. If
something else got in — a `sorry`, an axiom you did not intend — it tells you
what it found and asks before it changes anything.

PDF import works. A `.tex` source gives a much better result.

A run takes hours and spends real money on model calls. You can stop it at any
time. The side bar offers to pick up where it left off.

## Reporting a bug

[**Open an issue.**](https://github.com/meelgroup/tex2lean-releases/issues/new/choose)

Two things make a report fixable, and both are easy to forget:

- **The version.** It is in the Extensions pane, or run `tex2lean --version`.
- **The log.** Run *Tex2Lean: Show extension log*, or click **Log** at the
  bottom of the side bar. Paste the part around whatever went wrong. A few
  hundred lines is plenty.

If it is about one paper and you can share the `.tex`, say so. Most odd
behaviour comes from a statement the scan read differently than you did.

The log records file paths, statement names, and what the agents did. It does
not record your API keys. Read it before you paste it, and cut anything you
would rather not publish.

## Source

Not public at the moment. This repository carries the packaged extension and the
issue tracker.

## Licence

See [LICENSE](LICENSE). Free to install and use, including for commercial and
academic work. What the extension writes into your workspace is yours.

Built at Georgia Tech.
