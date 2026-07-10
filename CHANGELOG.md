# Changelog

This changelog starts from the Android closed testing stabilization phase.

## 0.3.0+10

### Changed

- Restored the About dialog's version and build display using Android package
  metadata from the installed application.
- Removed reliance on a hardcoded build number without adding a new package
  dependency.

## 0.3.0+9 - 2026-07-09

### Added

- Added Google Play In-App Updates with an Android-only flexible update flow.
- Added localized update-ready and installation prompts.
- Added the approved Supabase/PostgreSQL database foundation, including ordered
  migrations, a standalone creation script, schema specification, ERD, ADRs,
  storage configuration, and verification queries.

## 0.3.0+8 - 2026-07-09

### Fixed

- Fixed the Android release-only barcode scanner initialization failure caused
  by ML Kit component discovery in release builds.
- Added ProGuard keep rules for ML Kit and Firebase component registrars.
- Pinned `mobile_scanner` to version `7.1.4` and retained the unbundled ML Kit
  configuration.

### Changed

- Improved `MobileScannerController` lifecycle handling.
- Added temporary on-screen scanner diagnostics during the release
  investigation.

### Documentation

- Added a detailed troubleshooting record covering symptoms, investigation,
  native `logcat` findings, root cause, resolution, and device validation.

## 0.3.0+3 - 2026-07-02

### Added

- Added the About dialog.
- Added optional product images and major inventory workflow improvements.

## Earlier Milestones

### Added

- Established the first stable inventory counting workflow with barcode
  scanning and native Android scan confirmation.
- Added employee management, branch management, responsive application layout,
  and local Drift persistence.
