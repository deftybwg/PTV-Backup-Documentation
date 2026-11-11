# Pentest Vault Encrypted Backup

A simple Linux backup solution that compresses, encrypts and uploads my personal PTV knowledge base to Google Drive.

The process uses `tar`, `gzip`, `GPG` and `rclone` to create encrypted, timestamped backups that can be restored on another Linux host.

## Overview

The backup process follows this workflow:

```text
/home/ben/PTV
      |
      v
  tar + gzip
      |
      v
  GPG symmetric encryption
      |
      v
PTV-YYYY-MM-DD_HH-MM-SS.tar.gz.gpg
      |
      v
   rclone
      |
      v
 Google Drive
```

## Requirements

The following tools are required:

| Tool | Purpose |
|---|---|
| `tar` | Archive the PTV directory |
| `gzip` | Compress the archive |
| `gpg` | Symmetric encryption |
| `rclone` | Google Drive integration |

Install dependencies on Debian/Kali-based systems:

```bash
sudo apt update
sudo apt install -y gnupg rclone
```

## Configuration

### Source directory

The directory being backed up is:

```text
/home/ben/PTV
```

The PTV directory contains personal cybersecurity notes, research, templates and lab documentation.

### Google Drive

Google Drive is configured through `rclone`.

The configured remote is named:

```text
gdrive
```

Backups are uploaded to:

```text
gdrive:PTV-backups
```

To configure rclone:

```bash
rclone config
```

To verify connectivity:

```bash
rclone lsd gdrive:
```

## Encryption methodology

This project uses **GPG symmetric encryption with AES-256**.

Encryption is performed using:

```bash
gpg --symmetric --cipher-algo AES256
```

### Why symmetric encryption?

Symmetric encryption was deliberately chosen over public/private key encryption.

The primary reasons are:

- **Portability:** Backups can be decrypted on any host with GPG installed.
- **Simplicity:** Restoration only requires the original passphrase.
- **No private-key management:** There is no need to export, import or maintain a separate GPG private key across machines.
- **User-controlled access:** The passphrase is only required when encrypting or decrypting an archive.

### Passphrase handling

The encryption passphrase is entered interactively through GPG's passphrase prompt.

The passphrase is deliberately NOT:
- Stored in a plaintext file.
- Hardcoded into the backup script.
- Passed as a command-line argument.
- Stored in the Git repository.

This means the backup process requires user interaction when encryption is performed.

**Important:** The passphrase must be retained securely in a password manager or another safe location. Losing it means the encrypted backups cannot be recovered.

GPG may temporarily cache the passphrase through its agent, depending on the local configuration.

## Backup process

The backup script is located at:

```text
~/scripts/backup-ptv.sh
```

To execute:

```bash
~/scripts/backup-ptv.sh
```

The script performs the following operations:

1. Generates a timestamp for the backup filename.
2. Creates a compressed `.tar.gz` archive of the PTV directory.
3. Encrypts the archive using GPG AES-256 symmetric encryption.
4. Removes the unencrypted archive.
5. Uploads the encrypted archive to Google Drive using rclone.

### Backup naming convention

Backups use the following naming convention:

```text
PTV-YYYY-MM-DD_HH-MM-SS.tar.gz.gpg
```

For example:

```text
PTV-2026-11-03_00-00-00.tar.gz.gpg
```

Timestamped backups allow multiple historical versions to be retained.

## Restoring a backup

To restore a backup on another Linux host:

### 1. Install the required tools

```bash
sudo apt install -y gnupg rclone
```

### 2. Download the backup

After configuring rclone:

```bash
rclone copy gdrive:PTV-backups ./
```

### 3. Decrypt and extract

```bash
gpg --decrypt PTV-2026-11-03_00-00-00.tar.gz.gpg | tar -xzvf -
```

GPG will prompt for the original encryption passphrase.

The PTV directory will be extracted into the current working directory.

### Alternative: Restore into a specific directory

```bash
mkdir -p ~/restore

gpg --decrypt PTV-2026-11-03_00-00-00.tar.gz.gpg \
    | tar -xzvf - -C ~/restore
```

## Repository structure

Suggested Git repository layout:

```text
ptv-backup/
├── README.md
├── backup-ptv.sh
├── systemd/
│   ├── ptv-backup.service
│   └── ptv-backup.timer
└── .gitignore
```

## Security considerations

- Never commit encryption passphrases or credentials.
- Never commit `rclone.conf` or other authentication material.
- Keep an independent copy of the GPG passphrase.
- Only encrypted backup archives should be uploaded to Google Drive.
- Test decryption and restoration periodically.
- Consider implementing backup retention to prevent unlimited storage consumption.
- Be aware that deleting an unencrypted temporary file with `shred` does not guarantee secure erasure on SSDs or copy-on-write filesystems.

## Future improvements

- [ ] Implement a systemd timer for scheduled backups.
- [ ] Add backup retention and automatic cleanup.
- [ ] Verify uploaded archive integrity.
- [ ] Add error handling and logging.
- [ ] Test restoration on a separate Linux host.
- [ ] Consider streaming compression directly into GPG to avoid creating an intermediate plaintext archive.

---

**Project objective:** Maintain a simple, portable and secure backup of my PTV knowledge base, with encrypted off-host storage on Google Drive and the ability to restore it on any Linux machine using GPG and my passphrase.
