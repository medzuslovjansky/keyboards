# Package Signing Keys

This directory contains the public GPG key used to sign our keyboard layout packages.

## Key Information

- **Key ID**: E6B8879DD8DAE6FFE8D2866CDCF241449612A027
- **Key Owner**: Interslavic OSS (Release key) <oss@interslavic.fun>
- **Key Usage**: Package signing for .deb and .rpm packages
- **Valid Until**: February 13, 2027

## For Users

### Debian/Ubuntu Users

```bash
# Import our public key into your GnuPG keyring
curl -fsSL https://raw.githubusercontent.com/medzuslovjansky/keyboards/main/linux/keys/public.gpg | gpg --import

# Verify the detached .deb signature (download both the .deb and the .deb.asc)
gpg --verify isv-keyboard_*.deb.asc isv-keyboard_*.deb
```

### Fedora Users

```bash
# Import our public key
rpm --import https://raw.githubusercontent.com/medzuslovjansky/keyboards/main/linux/keys/public.gpg

# Verify an .rpm package
rpm -K isv-keyboard-*.rpm
```

## For Maintainers

### Initial Key Setup

1. Generate a new GPG key:
   ```bash
   gpg --full-generate-key
   ```
   - Choose RSA and RSA (default)
   - Use 4096 bits
   - Set validity to 2 years
   - Use "Interslavic OSS (Release key)" as the name
   - Use the project email

2. Export the public key:
   ```bash
   # Get the key ID first
   gpg --list-secret-keys "Interslavic OSS"

   # Export the public key
   gpg --export -a "Interslavic OSS" > linux/keys/public.gpg
   ```

3. Add the signing key to GitHub:
   ```bash
   # Export the private key and add it as a secret
   gpg --export-secret-key -a "Interslavic OSS" | gh secret set GPG_SIGNING_KEY
   ```

### Key Rotation

1. Before the key expires:
   - Generate a new key following the steps above
   - Export both public and private keys
   - Update the GitHub secret
   - Commit the new public key
   - Update this README with new key details

2. Announce key changes:
   - Create a signed commit with key changes
   - Update release notes to mention key rotation
   - Keep the old public key for a transition period

### Security Best Practices

1. Store the private key securely
2. Use a strong passphrase
3. Keep the GitHub secret secure
4. Rotate keys every 2 years or if compromised
5. Only authorized maintainers should have access to signing keys

## Key History

| Key ID | Valid From | Valid Until | Status |
|--------|------------|-------------|---------|
| E6B8879DD8DAE6FFE8D2866CDCF241449612A027 | Feb 13, 2025 | Feb 13, 2027 | Current |
