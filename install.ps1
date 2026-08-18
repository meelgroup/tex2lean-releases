# Installs the tex2lean command line on Windows.
#
#   irm https://raw.githubusercontent.com/meelgroup/tex2lean-releases/main/install.ps1 | iex
#
# The same script as install.sh, in the language the other half of the machines
# speak. It downloads this repository's latest release, checks it against the
# published checksum, and puts one file in %LOCALAPPDATA%\Programs\tex2lean. It
# adds that directory to your user PATH, which is a per-user registry value and
# not a system one, and says so when it does.
#
# Removing it is deleting that directory. Upgrading is running this again.
#
# Overrides:
#   $env:TEX2LEAN_INSTALL_DIR = "C:\somewhere"
#   $env:TEX2LEAN_VERSION     = "v0.2.0"

$ErrorActionPreference = 'Stop'

$repo = 'meelgroup/tex2lean-releases'
$bin = 'tex2lean'
$dir = if ($env:TEX2LEAN_INSTALL_DIR) { $env:TEX2LEAN_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "Programs\$bin" }

function Die($msg) {
    Write-Host ''
    Write-Error "$bin install: $msg"
    exit 1
}

# Only one Windows build exists. An arm64 machine runs it under emulation, which
# is slow and works; a 32-bit one does not, and is told so rather than left with
# a file that will not start.
$archRaw = $env:PROCESSOR_ARCHITECTURE
if ($archRaw -eq 'x86' -and -not $env:PROCESSOR_ARCHITEW6432) {
    Die "this is a 32-bit Windows, and tex2lean is built for 64-bit only.`n       The VS Code extension does not need a matching build."
}
$asset = "$bin-win32-x64.exe"

$base = if ($env:TEX2LEAN_VERSION) {
    "https://github.com/$repo/releases/download/$($env:TEX2LEAN_VERSION)"
} else {
    "https://github.com/$repo/releases/latest/download"
}

Write-Host "$bin install"
Write-Host "  machine   Windows $archRaw  ->  $asset"
Write-Host "  release   $base"

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("tex2lean-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
    try {
        Invoke-WebRequest -Uri "$base/checksums.txt" -OutFile "$tmp\checksums.txt" -UseBasicParsing
    } catch {
        Die "cannot read $base/checksums.txt`n       Either there is no published release yet, or this machine cannot reach github.com."
    }

    $want = $null
    foreach ($line in Get-Content "$tmp\checksums.txt") {
        $parts = $line.Trim() -split '\s+'
        if ($parts.Length -ge 2 -and $parts[1] -eq "$asset.gz") { $want = $parts[0] }
    }
    if (-not $want) { Die "this release publishes no $asset.gz." }
    Write-Host "  expecting sha256 $want"

    try {
        Invoke-WebRequest -Uri "$base/$asset.gz" -OutFile "$tmp\$asset.gz" -UseBasicParsing
    } catch {
        Die "cannot download $base/$asset.gz"
    }

    # Before anything is unpacked. A mismatch installs nothing rather than
    # installing and warning.
    $got = (Get-FileHash "$tmp\$asset.gz" -Algorithm SHA256).Hash.ToLower()
    if ($got -ne $want.ToLower()) {
        Die ("the download does not match the published checksum.`n" +
             "         expected $want`n         got      $got`n" +
             "       Nothing has been installed. Try again; if it disagrees a second time, do`n" +
             "       not run the file — open an issue at https://github.com/$repo/issues")
    }

    # Windows has no gunzip, so the .gz is unpacked with the runtime's own
    # decompressor rather than by asking for a tool that is not there.
    $src = [System.IO.File]::OpenRead("$tmp\$asset.gz")
    $out = [System.IO.File]::Create("$tmp\$bin.exe")
    try {
        $gz = New-Object System.IO.Compression.GZipStream($src, [System.IO.Compression.CompressionMode]::Decompress)
        $gz.CopyTo($out)
        $gz.Dispose()
    } finally {
        $out.Dispose(); $src.Dispose()
    }

    $version = (& "$tmp\$bin.exe" --version 2>$null)
    if (-not $version) {
        Die "the downloaded binary does not run on this machine.`n       It matched its checksum, so the download is intact. Please open an issue at`n       https://github.com/$repo/issues"
    }

    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    # One move into place, so an interrupted install leaves the old binary
    # rather than half of the new one. A running tex2lean.exe holds a lock on
    # the file, which is why this says what to do rather than failing raw.
    try {
        Move-Item -Force "$tmp\$bin.exe" (Join-Path $dir "$bin.exe")
    } catch {
        Die "cannot write $dir\$bin.exe — if tex2lean is running, close it and try again."
    }

    Write-Host ''
    Write-Host "  installed $dir\$bin.exe  ($version)"

    # The user's own PATH, not the machine's: no elevation, and nothing another
    # account inherits. Already-open terminals keep the old PATH, which is worth
    # saying because it is the first thing that looks broken.
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (($userPath -split ';') -notcontains $dir) {
        [Environment]::SetEnvironmentVariable('Path', "$userPath;$dir", 'User')
        Write-Host ''
        Write-Host "  added $dir to your user PATH."
        Write-Host '  Open a new terminal for it to take effect.'
    }
    Write-Host ''
    Write-Host "  Run: $bin scan   (in the folder that holds your paper's .tex files)"
} finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
