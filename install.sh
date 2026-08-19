#!/bin/sh
# Installs the tex2lean command line.
#
#   curl -fsSL https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.sh | sh
#
# What it does, and nothing else: works out which build this machine needs,
# downloads it from this repository's latest release, checks it against the
# published checksum, and puts one file in ~/.local/bin. It does not touch your
# shell profile, your PATH, or anything outside that directory. If the directory
# is not on your PATH it prints the line to add and leaves the adding to you.
#
# Removing it is `rm ~/.local/bin/tex2lean`. Upgrading is running this again.
#
# Overrides:
#   TEX2LEAN_INSTALL_DIR=/somewhere    where the binary goes
#   TEX2LEAN_VERSION=v0.2.0            a release other than the latest
#
# This script is read by anyone who is about to pipe it into a shell, which is
# why it is short, why it prints every URL it uses, and why it refuses rather
# than guesses.

set -eu

REPO="meelgroup/tex2lean-releases"
BIN="tex2lean"
DIR="${TEX2LEAN_INSTALL_DIR:-${XDG_BIN_HOME:-$HOME/.local/bin}}"

die() {
	printf '\n%s: %s\n' "$BIN install" "$1" >&2
	exit 1
}

say() {
	printf '%s\n' "$1"
}

# Which build. Refused by name rather than guessed: a wrong architecture
# downloads 37 MB and dies with "cannot execute binary file", which tells the
# person nothing about what to do next.
os="$(uname -s)"
arch="$(uname -m)"
case "$os" in
Darwin) plat=darwin ;;
Linux) plat=linux ;;
*)
	die "$os is not a platform tex2lean is built for.
       Built for macOS and Linux. On Windows, use PowerShell:
         irm https://raw.githubusercontent.com/$REPO/main/install.ps1 | iex
       Or install the VS Code extension, which needs none of this."
	;;
esac
case "$arch" in
arm64 | aarch64) cpu=arm64 ;;
x86_64 | amd64) cpu=x64 ;;
*)
	die "$arch is not an architecture tex2lean is built for (arm64 and x86_64 are).
       The VS Code extension does not need a matching build; it runs wherever the editor does."
	;;
esac
asset="$BIN-$plat-$cpu"

# Where the release lives. `latest/download` is stable across releases, which is
# what makes the line at the top of this file safe to write down in a paper.
if [ -n "${TEX2LEAN_VERSION:-}" ]; then
	base="https://github.com/$REPO/releases/download/$TEX2LEAN_VERSION"
else
	base="https://github.com/$REPO/releases/latest/download"
fi

# One tool for downloading, one for hashing, and both are named if missing. A
# checksum this cannot compute is a checksum it will not skip.
if command -v curl >/dev/null 2>&1; then
	fetch() { curl -fsSL "$1" -o "$2"; }
elif command -v wget >/dev/null 2>&1; then
	fetch() { wget -qO "$2" "$1"; }
else
	die "neither curl nor wget is on this machine, so there is no way to download anything."
fi
if command -v shasum >/dev/null 2>&1; then
	digest() { shasum -a 256 "$1" | cut -d' ' -f1; }
elif command -v sha256sum >/dev/null 2>&1; then
	digest() { sha256sum "$1" | cut -d' ' -f1; }
else
	die "neither shasum nor sha256sum is on this machine.
       This script will not install a binary it cannot check, so it stops here.
       Install coreutils, or download the release by hand from
         https://github.com/$REPO/releases/latest"
fi

tmp="$(mktemp -d 2>/dev/null || mktemp -d -t tex2lean)"
# Nothing is left behind on any exit, including a failed one. A half-downloaded
# 37 MB file in /tmp is the kind of thing nobody finds for a year.
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

say "$BIN install"
say "  machine   $os $arch  ->  $asset"
say "  release   $base"

fetch "$base/checksums.txt" "$tmp/checksums.txt" ||
	die "cannot read $base/checksums.txt
       Either there is no published release yet, or this machine cannot reach github.com."

want="$(grep " $asset\.gz\$" "$tmp/checksums.txt" | cut -d' ' -f1 || true)"
[ -n "$want" ] ||
	die "this release publishes no $asset.gz.
       It lists: $(grep -v '^#' "$tmp/checksums.txt" | cut -d' ' -f3 | tr '\n' ' ')"

say "  expecting sha256 $want"
fetch "$base/$asset.gz" "$tmp/$asset.gz" ||
	die "cannot download $base/$asset.gz"

got="$(digest "$tmp/$asset.gz")"
# The check that gives this script the right to exist. It runs before anything is
# unpacked, and a mismatch installs nothing at all rather than installing and
# warning.
[ "$got" = "$want" ] ||
	die "the download does not match the published checksum.
         expected $want
         got      $got
       Nothing has been installed. Try again; if it disagrees a second time, do
       not run the file — open an issue at https://github.com/$REPO/issues"

gunzip -c "$tmp/$asset.gz" >"$tmp/$BIN" || die "the download did not unpack; gzip refused it."
chmod +x "$tmp/$BIN"

# Ask the binary what it is before it is installed. A file that cannot run here
# is better discovered now than the first time somebody types the command.
version="$("$tmp/$BIN" --version 2>/dev/null || true)"
[ -n "$version" ] ||
	die "the downloaded binary does not run on this machine.
       It matched its checksum, so the download is intact and the build is wrong for
       this system. Please open an issue at https://github.com/$REPO/issues and say
       what \`uname -sm\` prints: $os $arch"

mkdir -p "$DIR" || die "cannot create $DIR"
# Into place with one move, so an interrupted install leaves the old binary
# rather than half of the new one. A `tex2lean` that is running right now keeps
# running: the move replaces the directory entry, not the file it had open.
#
# Two statements rather than `A && B || C`, which shellcheck is right to flag:
# it reads as if-then-else and is not one. The half that mattered here is the
# middle case — the first move lands and the second does not — which used to
# die correctly and leave a 116 MB .incoming file in the directory forever.
mv "$tmp/$BIN" "$DIR/$BIN.incoming" || die "cannot write into $DIR"
mv "$DIR/$BIN.incoming" "$DIR/$BIN" || {
	rm -f "$DIR/$BIN.incoming"
	die "cannot write $DIR/$BIN"
}

say ""
say "  installed $DIR/$BIN  ($version)"

# On PATH or not, and never edited for you. A script that writes to a shell
# profile is a script that has to be undone by hand later, and it gets the file
# wrong on the machines that matter — a login shell that is not the interactive
# one, a profile that is generated, a shell nobody told it about.
case ":$PATH:" in
*":$DIR:"*)
	say ""
	say "  Run: $BIN scan   (in the folder that holds your paper's .tex files)"
	;;
*)
	# The tilde is text here, not a path: these two strings are printed for
	# somebody to read and retype, and never opened. `$HOME/.zshrc` would be
	# correct and would read worse in a sentence that says "add this to".
	# shellcheck disable=SC2088
	case "${SHELL:-}" in
	*/fish) profile="~/.config/fish/config.fish"; line="fish_add_path $DIR" ;;
	*/zsh) profile="~/.zshrc"; line="export PATH=\"$DIR:\$PATH\"" ;;
	*/bash) profile="~/.bashrc"; line="export PATH=\"$DIR:\$PATH\"" ;;
	*) profile="your shell's startup file"; line="export PATH=\"$DIR:\$PATH\"" ;;
	esac
	say ""
	say "  $DIR is not on your PATH, so the name will not work yet."
	say "  Add this to $profile, then open a new terminal:"
	say ""
	say "      $line"
	say ""
	say "  Or run it by its full path: $DIR/$BIN scan"
	;;
esac
