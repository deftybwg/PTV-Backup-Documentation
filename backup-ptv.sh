#!/usr/bin/env bash

set -Eeuo pipefail

# Configuration
SOURCE="/home/benxo"
BACKUP_DIR="/home/benxo/backups/PTV"
GDRIVE_REMOTE="gdrive:PTV-backups"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE="PTV-${TIMESTAMP}.tar.gz"
ENCRYPTED="${ARCHIVE}.gpg"

mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

echo "[*] Starting PTV backup..."

# Compress PTV
echo "[*] Creating compressed archive..."

tar -czf "$BACKUP_DIR/$ARCHIVE" \
    -C "$SOURCE" PTV

# Encrypt archive (interactive passphrase)
echo "[*] Encrypting archive..."

gpg --symmetric \
    --cipher-algo AES256 \
    --output "$BACKUP_DIR/$ENCRYPTED" \
    "$BACKUP_DIR/$ARCHIVE"

# Remove unencrypted archive
shred -u "$BACKUP_DIR/$ARCHIVE"

# Upload encrypted archive
echo "[*] Uploading to Google Drive..."

rclone copy "$BACKUP_DIR/$ENCRYPTED" "$GDRIVE_REMOTE"

echo "[+] Backup completed successfully!"
echo "[+] Archive: $ENCRYPTED"

