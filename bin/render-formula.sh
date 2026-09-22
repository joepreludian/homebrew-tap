#!/bin/sh
# Regenerates Formula/docker-backup.rb for a released version of docker-backup.
#
#     bin/render-formula.sh 0.3.0
#
# The SHA-256 values come from the checksums file published with that release,
# so the formula cannot disagree with what GitHub is actually serving.

set -eu

REPO="joepreludian/docker-backup"

version="${1:-}"
if [ -z "$version" ]; then
    echo "usage: $0 <version>   (for example: $0 0.3.0)" >&2
    exit 2
fi
version="${version#v}"

root="$(unset CDPATH; cd -- "$(dirname -- "$0")/.." && pwd)"
template="$root/template/docker-backup.rb.tmpl"
output="$root/Formula/docker-backup.rb"

[ -f "$template" ] || { echo "missing template: $template" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM

sums="$tmp/SHA256SUMS"
curl -fsSL -o "$sums" \
    "https://github.com/$REPO/releases/download/v${version}/SHA256SUMS" ||
    { echo "no SHA256SUMS is published for v${version}" >&2; exit 1; }

# Looks up one archive's digest. Fails loudly rather than letting a half
# published release render a formula with an empty sha256 in it.
digest() {
    name="docker-backup-${version}-$1.tar.gz"
    value="$(awk -v want="$name" '
        { file = $2; sub(/^\.\//, "", file); if (file == want) { print $1; exit } }
    ' "$sums")"
    if [ -z "$value" ]; then
        echo "$name is missing from the v${version} checksums" >&2
        exit 1
    fi
    echo "$value"
}

darwin_arm64="$(digest aarch64-apple-darwin)"
darwin_x86_64="$(digest x86_64-apple-darwin)"
linux_arm64="$(digest aarch64-unknown-linux-musl)"
linux_x86_64="$(digest x86_64-unknown-linux-musl)"

mkdir -p "$(dirname "$output")"
sed \
    -e "s|@VERSION@|${version}|g" \
    -e "s|@SHA_DARWIN_ARM64@|${darwin_arm64}|g" \
    -e "s|@SHA_DARWIN_X86_64@|${darwin_x86_64}|g" \
    -e "s|@SHA_LINUX_ARM64@|${linux_arm64}|g" \
    -e "s|@SHA_LINUX_X86_64@|${linux_x86_64}|g" \
    "$template" >"$output"

echo "wrote $output for v${version}"
