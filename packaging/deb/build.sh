#!/bin/sh
# Build gaslight_<version>_all.deb into dist/.
#
# Architecture-independent: the payload is a POSIX shell script, so one .deb
# installs on amd64, arm64 and anything else that has /bin/sh.
#
#     sh packaging/deb/build.sh [version]
#
# Requires dpkg-deb (Debian/Ubuntu, or `brew install dpkg` on macOS).

set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
VERSION="${1:-$(sed -n 's/^__version__ = "\(.*\)"/\1/p' "$ROOT/gaslightai/__init__.py")}"
MAINTAINER="CataLift LLC <hello@gaslightai.dev>"

if ! command -v dpkg-deb >/dev/null 2>&1; then
    echo "error: dpkg-deb not found (apt install dpkg, or brew install dpkg)" >&2
    exit 1
fi

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

install -d -m 0755 "$STAGE/DEBIAN" "$STAGE/usr/bin" "$STAGE/usr/share/doc/gaslight"
install -m 0755 "$ROOT/bin/gaslight" "$STAGE/usr/bin/gaslight"
install -m 0644 "$ROOT/LICENSE" "$STAGE/usr/share/doc/gaslight/copyright"

cat > "$STAGE/DEBIAN/control" <<CONTROL
Package: gaslight
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Depends: \${misc:Depends}
Maintainer: $MAINTAINER
Homepage: https://gaslightai.dev
Description: An AI-native fork of Terraform
 Gaslight reads your HCL, decides what you probably meant, applies something
 close to it, and writes a state file explaining why that was the right call.
 .
 This package is satire. It makes no network calls, reads no configuration
 and changes nothing. Every command prints the same chalkboard.
CONTROL

# \${misc:Depends} is a debhelper substitution with no meaning here; drop it.
sed -i.bak '/^Depends: /d' "$STAGE/DEBIAN/control" && rm -f "$STAGE/DEBIAN/control.bak"

mkdir -p "$ROOT/dist"
OUT="$ROOT/dist/gaslight_${VERSION}_all.deb"
dpkg-deb --build --root-owner-group "$STAGE" "$OUT" >/dev/null

echo "$OUT"
dpkg-deb --info "$OUT" | sed 's/^/  /'
