#!/usr/bin/env bash
#
# Minimal secure archival backup script for Fedora
# Requires: tar, openssl, par2cmdline, sha256sum
#
# Usage:
#   ./secure-archive-backup.sh /path/to/source /relative/destination/folder
#

set -euo pipefail

# --- Configuration ---
REDUNDANCY=20       # % of extra parity data (10–30% recommended)
ITERATIONS=250000   # PBKDF2 iterations for key stretching

# --- Check dependencies ---
for cmd in tar openssl par2 sha256sum; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "❌ Required tool '$cmd' is not installed."
        echo "   Install with: sudo dnf install $cmd"
        exit 1
    fi
done

# --- Inputs ---
if [ $# -lt 2 ]; then
    echo "Usage: $0 /path/to/source /relative/destination/folder"
    exit 1
fi

SOURCE="$1"
DEST="$2"
DEST="${DEST%/}"  # remove trailing slash if present
mkdir -p "$DEST"

DATE="$(date +%Y-%m-%d_%H-%M-%S)"
BASENAME="backup-${DATE}"
TARFILE="${DEST}/${BASENAME}.tar"
ENCFILE="${DEST}/${BASENAME}.tar.enc"
PARFILE="${ENCFILE}.par2"
HASHFILE="${ENCFILE}.sha256"

# --- Create TAR archive ---
echo "📦 Creating TAR archive..."
tar -cf "$TARFILE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

# --- Encrypt TAR ---
echo "🔐 Encrypting TAR with AES-256-CBC..."
openssl enc -aes-256-cbc -salt -pbkdf2 -iter "$ITERATIONS" \
  -in "$TARFILE" -out "$ENCFILE"

# Remove plaintext TAR after encryption
shred -u "$TARFILE"

# --- Generate PAR2 recovery files ---
echo "🧪 Generating PAR2 files (${REDUNDANCY}% redundancy)..."
par2 create -q -r"$REDUNDANCY" "$PARFILE" "$ENCFILE"

# --- Generate SHA256 checksum ---
echo "📝 Generating checksum..."
sha256sum "$ENCFILE" > "$HASHFILE"

echo "✅ Backup complete!"
echo "  📁 Archive:     $ENCFILE"
echo "  🧪 Parity:      $PARFILE"
echo "  🔑 Checksum:    $HASHFILE"
