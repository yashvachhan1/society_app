# photo_picker.dart

Mirrors `lib/core/utils/photo_picker.dart`.

**Purpose** — lets the resident set `users.photo_url` for real: take a photo
with the camera or choose one from the gallery.

## What's inside

- `PickedPhoto` — the chosen image as `bytes` + `fileName`.
  - `PickedPhoto.removed` — the result when the resident clears their photo
  - `isRemoval` — true for that result
- `pickProfilePhoto(context, {allowRemove})` → `Future<PickedPhoto?>`
  Shows a bottom sheet (Take a photo · Choose from gallery · Remove photo),
  then opens `image_picker` with `maxWidth/maxHeight 1024` and `imageQuality 85`.
  Returns null if the resident cancels.
- `_PhotoSourceSheet` / `_SourceTile` — the private bottom sheet UI

## Used by

Registration step 2 and the profile screen (header avatar and the
"Profile photo" row).

## Notes

- Images are read as **bytes**, not a file path, so the same code works on
  Android, iOS and web.
- Platform setup: `image_picker` in `pubspec.yaml`; iOS needs
  `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` in
  `Info.plist` (already added). Android needs nothing extra.
- The bytes stay in memory until there is a backend to upload them to; then
  they become a `files` row and the resulting URL goes into `users.photo_url`.
