#!/usr/bin/env bash
#
# Vercel build for ONE Flutter web app in this monorepo.
#
# Keep the Vercel project's "Root Directory" at the REPO ROOT (blank). Pick the
# app with the APP_DIR environment variable (Settings -> Environment Variables):
#     admin     ->  APP_DIR = apps/admin   (this is also the default)
#     owner     ->  APP_DIR = apps/owner
#     resident  ->  APP_DIR = apps/resident
#
# The chosen app is built and its web output copied to ./public (served by
# vercel.json). Running from the repo root means the shared packages/core path
# dependency resolves with no extra Vercel settings.
#
set -euo pipefail

APP_DIR="${APP_DIR:-apps/admin}"
FLUTTER_VERSION="3.44.1"
FLUTTER_HOME="${HOME}/flutter"

if [ ! -d "${APP_DIR}" ]; then
  echo "✗ APP_DIR='${APP_DIR}' not found. Use apps/admin, apps/owner or apps/resident." >&2
  exit 1
fi

echo "▶ Target app: ${APP_DIR}"
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

echo "▶ Building ${APP_DIR} (web, release) ..."
( cd "${APP_DIR}" && flutter pub get && flutter build web --release )

echo "▶ Publishing ${APP_DIR}/build/web -> public/"
rm -rf public
cp -r "${APP_DIR}/build/web" public

echo "✓ Done — serving ${APP_DIR} from public/"
