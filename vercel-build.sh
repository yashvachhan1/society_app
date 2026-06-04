#!/usr/bin/env bash
#
# Vercel build step for the admin web dashboard (apps/admin).
#
# Vercel's build image does not ship with Flutter, so we install a pinned
# Flutter SDK, then build the web app. The build runs from the repo root so the
# monorepo path dependency (society_core in packages/core) resolves correctly.
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
    echo "  Archive unavailable — cloning via git instead ..."
    rm -rf "${FLUTTER_HOME}"
    git clone https://github.com/flutter/flutter.git --depth 1 -b "${FLUTTER_VERSION}" "${FLUTTER_HOME}" \
      || git clone https://github.com/flutter/flutter.git --depth 1 -b stable "${FLUTTER_HOME}"
  fi
fi

export PATH="${FLUTTER_HOME}/bin:${PATH}"
# Vercel runs as a different user than the one that cloned Flutter; mark it safe.
git config --global --add safe.directory "${FLUTTER_HOME}" || true

flutter --version
flutter config --enable-web --no-analytics

echo "▶ Building the admin web app (apps/admin) ..."
cd apps/admin
flutter pub get
flutter build web --release

echo "✓ Build complete → apps/admin/build/web"
