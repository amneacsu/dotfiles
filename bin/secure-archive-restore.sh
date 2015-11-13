#!/usr/bin/env bash
#
# Secure archival restore script
# Verifies integrity, repairs corruption with PAR2, decrypts, and extracts.
#
# Usage:
#   ./secure-archive-restore.sh <encrypted-archive-file> <destination-folder>
#

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <encrypted-archive-file> <destination-folder>"
    exit 1
fi

ENCFILE="$1"
DEST="$2"
DEST="${DEST%/}"  # remove trailing slash if present
mkdir -p "$DEST"

BASENAME="$(basename "${ENCFILE%.enc}")"
PARFILE="${ENCFILE}.par2"
HASHFILE="${ENCFILE}.sha256"
TARFILE="${DEST}/${BASENAME}.tar"

# --- Verify checksum ---
if [ -f "$HASHFILE" ]; then
    echo "📝 Verifying SHA256 checksum..."
    if sha256sum -c "$HASHFILE"; then
        echo "✅ Checksum OK"
    else
        echo "⚠️ Checksum mismatch — proceeding to PAR2 verification..."
    fi
else
    echo "ℹ️ No checksum file found, skipping SHA256 verification."
fi

# --- Verify / Repair with PAR2 ---
if [ -f "$PARFILE" ]; then
    echo "🧪 Verifying with PAR2..."
    if par2 verify -q "$PARFILE"; then
        echo "✅ PAR2 verification OK"
    else
        echo "⚠️ Archive corrupted, attempting repair..."
        par2 repair "$PARFILE"
        echo "✅ Repair complete"
    fi
else
    echo "ℹ️ No PAR2 file found, skipping parity check."
fi

# --- Decrypt ---
echo "🔐 Decrypting..."
if command -v age &>/dev/null && grep -q "age-encryption" "$ENCFILE" 2>/dev/null; then
    # Using age encryption
    age -d -o "$TARFILE" "$ENCFILE"
else
    # OpenSSL AES-CBC encryption
    openssl enc -d -aes-256-cbc -salt -pbkdf2 -iter 250000 -in "$ENCFILE" -out "$TARFILE"
fi

# --- Extract ---
echo "📦 Extracting TAR archive..."
tar -xf "$TARFILE" -C "$DEST"

# Optionally delete the decrypted tar to avoid leaving plaintext
shred -u "$TARFILE"

echo "✅ Restore complete!"
echo "   📁 Restored to: $DEST"
