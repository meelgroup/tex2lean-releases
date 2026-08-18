# Changelog

Only user-visible changes are listed here.

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
