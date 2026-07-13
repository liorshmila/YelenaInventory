# Release Build Scripts

## Android Google Play Release

Google Play release builds for Yelena Inventory must include the Supabase
configuration at compile time. Do not build Google Play AABs with a plain:

```powershell
flutter build appbundle --release
```

The release script loads the required Supabase values from the local file:

```text
scripts/release.env.ps1
```

This file must stay local and must not be committed. It should define:

```powershell
$env:SUPABASE_URL = "https://your-project.supabase.co"
$env:SUPABASE_PUBLISHABLE_KEY = "your-supabase-publishable-key"
```

All release commands must be run from the repository root.

Example:

```powershell
cd C:\Dev\YelenaInventory
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
& .\scripts\build_android_release.ps1
```

Before building, the script automatically increments only the Flutter build
number in `yelena_inventory/pubspec.yaml`.

Example:

```text
0.3.0+14 -> 0.3.0+15
```

The semantic version is not changed.

The generated AAB is written to:

```text
yelena_inventory/build/app/outputs/bundle/release/app-release.aab
```

The script fails before building if either Supabase value is missing. If the
Flutter build fails, the script reports the failure and exits with a non-zero
exit code without retrying.
