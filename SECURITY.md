# Security Policy

## Package Verification

### Our Official GPG Key

All official releases are signed with our GPG key:

```
Key ID: E6B8879DD8DAE6FFE8D2866CDCF241449612A027
Owner: Interslavic OSS (Release key) <oss@interslavic.fun>
```

You can verify our key on keys.openpgp.org: [E6B8879DD8DAE6FFE8D2866CDCF241449612A027](https://keys.openpgp.org/vks/v1/by-fingerprint/E6B8879DD8DAE6FFE8D2866CDCF241449612A027)

### Verifying Downloads

Always verify the signature of downloaded packages:

#### Debian/Ubuntu
```bash
# Import our public key into your GnuPG keyring
curl -fsSL https://raw.githubusercontent.com/medzuslovjansky/keyboards/main/linux/keys/public.gpg | gpg --import

# Verify the detached .deb signature (download both the .deb and the .deb.asc)
gpg --verify isv-keyboard_*.deb.asc isv-keyboard_*.deb
```

#### Fedora/Rocky Linux
```bash
# Import our public key
rpm --import https://raw.githubusercontent.com/medzuslovjansky/keyboards/main/linux/keys/public.gpg

# Verify package
rpm -K isv-keyboard-*.rpm
```

### Official Distribution Channels

Our packages are only distributed through:
1. GitHub Releases on this repository
2. (Future) Official distribution repositories

Do not download packages from other sources.

## Reporting a Vulnerability

If you discover a security vulnerability, please:

1. **DO NOT** open a public issue
2. Email us at oss@interslavic.fun with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - (Optional) Suggested fix

We will:
- Acknowledge receipt within 48 hours
- Provide a detailed response within 7 days
- Prioritize fixing critical vulnerabilities
- Credit you in the security advisory (unless you prefer to remain anonymous)

## Security Updates

- We announce security updates through GitHub releases
- Critical updates are also announced via our mailing list
- All security fixes are tagged with "security" in release notes

## Key Rotation Policy

- Keys are valid for 2 years
- Key rotation announcements are made 30 days in advance
- Old keys are kept valid for a 60-day transition period
- Emergency rotation may occur if key compromise is suspected
