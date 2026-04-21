# Interslavic Keyboard Layout for macOS

Drag-to-install `.dmg` with the **Interslavic (ABC)** Latin layout. Source `.keylayout` files are the authoritative input; the Makefile assembles a macOS keyboard `.bundle` and packages it into a distributable DMG.

## Repository Structure

```
mac/
├── src/           # *.keylayout (XML authored in Ukelele or by hand)
├── templates/     # Info.plist.in, version.plist.in, InfoPlist.strings.in
├── scripts/       # build-bundle.sh, build-dmg.sh
├── Makefile       # test / bundle / package-dmg / dist / clean
└── README.md
```

## Building

Prerequisites: macOS. `hdiutil`, `plutil`, and `make` all ship by default — nothing to install.

| Target               | Result                                              |
| -------------------- | --------------------------------------------------- |
| `make test`          | Sanity-check source `.keylayout` and templates      |
| `make bundle`        | `build/Interslavic (ABC).bundle/`                   |
| `make package-dmg`   | `packages/interslavic-abc-<version>.dmg`            |
| `make dist`          | `isv-keyboard-mac-<version>.tar.gz` (source)        |
| `make clean`         | Remove `build/`, `packages/`, dist tarball          |

The default version is `1.0`; override with `VERSION=1.2.3 make package-dmg`.

## Installation (end-user)

1. Download the `.dmg` from [Releases](https://github.com/medzuslovjansky/keyboards/releases) and open it.
2. Drag `Interslavic (ABC).bundle` onto the **Keyboard Layouts** shortcut inside the DMG.
   - Installs for all users into `/Library/Keyboard Layouts/` (requires admin).
   - For the current user only, drag into `~/Library/Keyboard Layouts/` instead.
3. **Log out and log back in.** macOS will not pick up a new keyboard bundle otherwise.
4. **System Settings → Keyboard → Text Input → Input Sources → + → Other → Interslavic (ABC)**.

The DMG is currently unsigned. On first install macOS may show a Gatekeeper warning — right-click the bundle → *Open* to approve.

## Development

### Iterate on the layout

```bash
make bundle
cp -R "build/Interslavic (ABC).bundle" ~/Library/Keyboard\ Layouts/
# log out and back in (required — macOS caches the layout list)
# test in System Settings → Keyboard → Text Input → Input Sources
```

Edit `src/Interslavic (ABC).keylayout` with [Ukelele](https://software.sil.org/ukelele/) (SIL, free GUI editor) or by hand — the file is plain XML.

### Build the full DMG

```bash
make clean && make package-dmg
open packages/interslavic-abc-1.0.dmg   # sanity-check the mount
```

## Uninstalling

```bash
rm -rf ~/Library/Keyboard\ Layouts/"Interslavic (ABC).bundle"
# or /Library/Keyboard Layouts/ if installed system-wide
```

Also remove the entry from **System Settings → Keyboard → Text Input → Input Sources** if it was added.

## Troubleshooting

- **Layout doesn't appear in Input Sources.** You need to log out and back in after copying the bundle — macOS only rescans keyboard layouts at login.
- **`xmllint` fails on the `.keylayout`.** Ukelele writes XML 1.1 (to allow control characters like `&#x0008;` for backspace); macOS's `xmllint` only supports XML 1.0. This is expected — the Apple runtime parser handles 1.1 correctly. The build deliberately does not run `xmllint` on keylayouts.
- **DMG won't open: "damaged".** Usually a transfer error — re-download. If building locally, `make clean && make package-dmg`.

## Contributing

- Edit the `.keylayout` in Ukelele or by hand. Keep the filename matching `KLInfo_*` display name in `Info.plist.in`.
- Run `make package-dmg` and install locally to verify before opening a PR.
- New layout variants (Cyrillic etc.) should ship as additional bundles with their own bundle identifier (e.g. `org.interslavic.keyboards.cyrl`).

## License

Apache-2.0 — see the top-level [`LICENSE`](../LICENSE).
