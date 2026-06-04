#!/usr/bin/env bash
#
# Builds ONE Flutter web app for Vercel. Each app's vercel.json
# (apps/<app>/vercel.json) runs this via `bash ../../vercel-build.sh`, so the
# "current app" is simply the Vercel Root Directory (e.g. apps/owner) that this
# command runs in.
#
# In the Vercel project you must:
#   1. set Root Directory to the app folder (apps/admin | apps/owner | apps/resident)
#   2. enable "Include files outside the Root Directory in the Build Step"
#      (so the shared packages/core path dependency resolves)
#
set -euo pipefail

FLUTTER_VERSION="3.44.1"
FLUTTER_HOME="${HOME}/flutter"

echo "▶ Building the Flutter web app in: $(pwd)"
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

echo "✓ Done → $(pwd)/build/web"
