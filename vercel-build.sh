#!/usr/bin/env bash
#
# Vercel build for the Society app (Flutter web).
#
# Vercel's build image has no Flutter, so we install a pinned SDK and then build
# the web bundle. Keep the project's "Root Directory" at the repo root (blank);
# vercel.json serves build/web.
#
set -euo pipefail

FLUTTER_VERSION="3.44.1"
FLUTTER_HOME="${HOME}/flutter"

echo "▶ Installing Flutter ${FLUTTER_VERSION} ..."
if [ ! -x "${FLUTTER_HOME}/bin/flutter" ]; then
  ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${ARCHIVE}"
  if curl -fSL --retry 3 "${URL}" -o /tmp/flutter.tar.xz \
     && tar -xf /tmp/flutter.tar.xz -C "${HOME}"; then
    echo "  Installed Flutter from the official archive."
  else
    echo "  Archive unavailable — cloning via git ..."
    rm -rf "${FLUTTER_HOME}"
    git clone https://github.com/flutter/flutter.git --depth 1 -b "${FLUTTER_VERSION}" "${FLUTTER_HOME}" \
      || git clone https://github.com/flutter/flutter.git --depth 1 -b stable "${FLUTTER_HOME}"
  fi
fi

export PATH="${FLUTTER_HOME}/bin:${PATH}"
git config --global --add safe.directory "${FLUTTER_HOME}" || true

flutter --version
flutter config --enable-web --no-analytics

echo "▶ flutter pub get && flutter build web --release ..."
flutter pub get
flutter build web --release

echo "✓ Done → build/web"
