# Pentest Vault Encrypted Backup

A simple Linux backup solution that compresses, encrypts and uploads my personal PTV knowledge base to Google Drive.

The process uses `tar`, `gzip`, `GPG` and `rclone` to create encrypted, timestamped backups that can be restored on another Linux host.

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

The PTV directory contains personal cybersecurity notes, research, templates and lab documentation.

```
sudo chown -R benxo:benxo /home/benxo/backups
sudo chmod 700 /home/benxo/backups/PTV
```

Ifu doing this on a new host, to configure rclone:

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

## Running the script:

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

1. Decrypt and extract

```bash
gpg --decrypt PTV-2026-11-03_00-00-00.tar.gz.gpg | tar -xzvf -
```
