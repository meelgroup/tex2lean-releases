# Tex2Lean

Tex2Lean turns mathematical results from a paper into a Lean 4 project. It is
designed primarily for papers that state an algorithm and prove a theorem about
its output.

For each selected result, Tex2Lean:

- reads the paper's LaTeX source;
- translates the relevant pseudocode and mathematical model into Lean;
- states the result against the translated program;
- builds and checks the proof with Lean; and
- reports ambiguities or defects that require the author's input.

This repository provides Tex2Lean downloads, installation instructions, and the
issue tracker.

## Install the extension

Search for **Tex2Lean** in the VS Code Extensions view and select **Install**.

You can also download the latest `.vsix` from
[meelgroup/tex2lean-releases](https://github.com/meelgroup/tex2lean-releases/releases/latest)
and choose **Extensions** → **···** → **Install from VSIX…**.

From a terminal:

```sh
code --install-extension tex2lean4.vsix
```

After installing or upgrading, reload the VS Code window to load the extension.

## Get started

Open the folder containing your paper's `.tex` files, then run
**Tex2Lean: Open in Side bar** from the command palette.

1. Select **Set Up**. This installs and builds the Lean environment and is
   normally required only once per machine.
2. Select **Scan LaTeX sources**. Tex2Lean lists the main results it found in
   the paper.
3. Select **Formalize** next to a result. To process multiple results in
   sequence, select **Formalize several…**.

LaTeX source produces the best results. PDF import is also available when
`pdftotext` or `mutool` is installed.

Saved `theorem` and `lemma` declarations under the Lean project's `Model/`
directories also appear in **Lean statements**. Declarations already linked to
paper statements keep their existing paper rows. For a new theorem, write its
statement with a `sorry` proof, save the file, and select **Prove**. Tex2Lean
checks the declaration with Lean and proves it directly, without restating it
from TeX. The row supports **Resume**, **Recheck Lean**, and navigation to its
declaration. This also works without a paper scan. Use **Refresh Lean statements**
if you need to refresh the list manually.

OpenRouter is available under **Connect → OpenRouter key**. Save your key there
and set `formalize.openrouter.model` to a model slug from the
[OpenRouter catalog](https://openrouter.ai/models), or leave it as `openrouter/auto`.
For the CLI, set `OPENROUTER_API_KEY` and use
`--provider openrouter --model <model-slug>`. Selecting OpenRouter uses `@openrouter/agent` for proof workers and project chat,
with local file and Lean tools; no Claude or Codex CLI is required. Selecting
Claude CLI or Codex CLI uses that CLI. OpenRouter also handles planning and review
passes. Choose a model that supports tool calling.

## Requirements

- VS Code 1.90 or newer
- Git
- One supported model connection:
  - a Claude Pro or Max subscription with
    [Claude Code](https://claude.com/download) signed in;
  - a ChatGPT Plus or Pro subscription with
    [Codex](https://openai.com/codex) signed in; or
  - an [Anthropic](https://console.anthropic.com/) or
    [OpenAI](https://platform.openai.com/) or
    [OpenRouter](https://openrouter.ai/settings/keys) API key

Tex2Lean installs Lean, but it does not install Git. The initial Mathlib build
can take some time and requires several gigabytes of disk space.

## Project-aware chat

Questions in the run chat go to the selected coding agent. It can inspect the
current paper, Lean sources, proof state, and run evidence before answering,
but question turns are read-only.
Explicit change requests—and follow-ups such as **do it** after a proposed next
step—first ask you to pause any active Tex2Lean run. No editing agent starts
until the run is paused; you can then retry the preserved request with
**Change this**. The write turn runs inside Tex2Lean's checked change workflow.

The agent treats each library's `Model/` directory as the user-facing audited
contract: definitions, assumptions, program semantics, and theorem statements.
`Interface/` bridges that contract to proof representations, while `Analysis/`
contains proof implementation. Changes are rebuilt and checked for scope before
they are kept.

## Command-line version

The experimental command-line version is available for macOS, Linux, and
Windows. It uses the same project as the extension; only one Tex2Lean run can
work on that project at a time.

On macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.sh | sh
```

On Windows, run the following in PowerShell:

```powershell
irm https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.ps1 | iex
```

The installer downloads the executable for your platform and checks it against
`checksums.txt` from the release. No separate Node installation is required.
On macOS and Linux, ensure `~/.local/bin` is on your `PATH`.

Set up the Lean environment, then run these commands in your paper's folder:

```sh
tex2lean setup
tex2lean scan
tex2lean all
```

Run `tex2lean --help` to see the available commands. To update the CLI:

```sh
tex2lean upgrade
```

In an interactive terminal, `/help` lists the available prompt commands.
Use `/targets` to list results, `/show t3` to inspect a result, and `/quit` to
leave the prompt. During a run, press **p** to request a pause or **Ctrl+C** to
stop it.

You can also download the executable for your platform from the
[latest release](https://github.com/meelgroup/tex2lean-releases/releases/latest)
and verify its SHA-256 against `checksums.txt`. The installation scripts are
available here as [install.sh](install.sh) and [install.ps1](install.ps1).

## Report a problem

[Open an issue](https://github.com/meelgroup/tex2lean-releases/issues/new/choose)
and include:

- the Tex2Lean version shown in the Extensions view, or `tex2lean --version`; and
- the relevant portion of the extension log, available through
  **Tex2Lean: Show extension log** or the **Log** button in the side bar.

Please review the log before posting it and remove any information you do not
want to share publicly.

Questions can also be sent to [meel@gatech.edu](mailto:meel@gatech.edu).

## Source and license

Tex2Lean's source is not currently public. This repository distributes the
packaged extension and CLI executables and hosts the issue tracker.

See [LICENSE](LICENSE) for usage terms. Built at Georgia Tech.
