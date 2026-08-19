# Changelog

Only user-visible changes are listed here.

## 0.2.2

**A new install says what to do first**

- Until Mathlib and arlib are built here, every `tex2lean` command starts with
  one line saying so and naming `tex2lean setup`. It stops the moment the
  machine is set up, and it never appears over `setup` itself.
- The `tex2lean>` prompt says the same thing in the form that works there:
  `/setup`.
- Refusals at the prompt now name the prompt's own commands. "not set up —
  /setup first" rather than "run `tex2lean setup`", which was an instruction to
  leave the prompt you were sitting at.

**Keeping the tool up to date**

- New: `tex2lean upgrade`. It says which version is installed and which is out,
  and asks before downloading anything.
- It checks the download against the published SHA-256 and runs it once before
  replacing anything. If any of that fails, nothing changes.
- It refuses to overwrite a copy Homebrew, npm or nix installed, and says what
  to run instead.
- `checksums.txt` now names the release it belongs to.

**Typing at the prompt**

- After a command finishes, the terminal stays open at a `tex2lean>` prompt
  instead of exiting. `/quit` leaves. A script, a pipe or `--yes` never sees it.
- `/help` lists what you can type now, and what is unavailable with the reason.
- Commands: `/scan`, `/plan`, `/prove`, `/all`, `/check`, `/proved`, `/handoff`,
  `/map`, `/ci`, `/index`, `/recheck`, `/assumptions`, `/donate`, `/resume`,
  `/setup`, `/connect`, `/upgrade`.
- New: `/targets [filter]` lists the statements and how far each has got.
  `/show <id>` says where one is in the paper; `/lean <id>` says what carries it
  in Lean. Naming more than one lists them and picks none.
- New: `/root` forgets which `.tex` is the paper, so the next scan asks again.
- The same four also work from a shell: `tex2lean targets`, `tex2lean show <id>`,
  `tex2lean lean <id>`, `tex2lean root`.
- `/status` and `/log [n]` say what this window did and what it said.
- New: `/agents [n]` and `/model [name]` — with no argument, what is in force.
  Also `tex2lean agents` and `tex2lean model`.
- Anything that does not start with `/` is a note for the run. It joins the same
  standing instructions the side bar's chat box writes to and leads the next
  agent's brief. `/say <text>` is the same thing said explicitly.

**Pausing a run in a terminal**

- Press `p` while a run is going. It stops at its next boundary and keeps what
  it has, the same as the Pause button in the side bar. Before this a terminal
  could only stop a run.
- ctrl-c still stops now. Both are listed at the start of every run.
- A question opened during a run still gets your keypress.

**Saying what the commands do**

- `tex2lean --help` now groups the commands by what you are doing — setting up,
  reading the paper, doing the work, checking it — and describes each in one
  plain sentence.
- `/help` at the prompt uses the same sentences, so a command is described the
  same way wherever you meet it.

**Reading the right paper**

- A folder with more than one `\documentclass` file no longer offers them
  shortest-filename-first. A cover letter beat a manuscript that way.
- The list now says why each file is where it is — how many theorems it states,
  whether its class is one a paper ever uses.
- The files are now the numbered choices themselves. Press the number of the
  one you want. Before, the numbers pressed the buttons under the list.
- Pressing return takes the likeliest file. With `--yes`, the command line used
  to take nothing and exit as if it had scanned.
- `--answer rootFile=journalmain.tex` names a file, matching on the start of it.
  A mistyped `--answer` is now refused, with the list of what it could have been.
- Your choice is saved in the paper's own folder, in `.blueprint/root.json`.
  It used to be one setting for the whole machine, so scanning a second paper
  reused the first paper's file. Delete that file to be asked again.
- An empty scan says which other files could be the paper, and offers to read
  one of them instead of leaving you with "this paper has no theorems".

## 0.2.0

First release published here. Earlier builds were handed out directly, so this
lists everything new since 0.1.17.

**The command line**

- New: `tex2lean`, the same program in a terminal. Install it with one line;
  see the README.
- One self-contained file per platform. It needs no Node and no editor.
- macOS, Linux and Windows, on Intel and ARM.
- The installer checks the download against a published SHA-256 and installs
  nothing if it does not match.
- It does not edit your shell profile. If the directory is not on your PATH it
  prints the line to add.
- `tex2lean --version` now reports the real version. Every build before this
  said `0.0.0-dev`.

**Statement rows**

- Every row now shows its buttons all the time. They no longer wait for a hover.
- New **.tex** button. Opens the statement in your paper.
- New **.lean** button. Appears once a statement has been formalized.
- New **Recheck** button. See below.
- The statement text is plain text now. Use **.tex** to open it.

**Recheck**

- Asks Lean about a finished statement again.
- Clean axioms: it says so and stops.
- Anything else: it tells you what it found and asks before changing anything.

**Stopping a run**

- The offer to resume a stopped run is now **Resume** or **Discard**.
- **Discard** deletes the resume record so you are not asked again.
- Your Lean proofs are never touched by Discard.

**Refused commands**

- When agents have commands refused, you now get a list with a tick box each.
- You choose which to allow. Nothing you leave unticked is granted.

**Speed**

- Mathlib declaration names are now indexed on your machine.
- Planning agents look names up instead of searching Mathlib file by file.

**Fixes**

- A paper with overlapping LaTeX environments could give one label to two
  statements. Fixed.
- The background watchdog could flood its own log with the same line. Fixed.

**Your Lean project**

- New projects no longer get `scripts/handoff-check.sh`. The checks run inside
  the extension now. Projects made by older versions keep their copy; deleting
  it is safe.
