# Release Build Scripts

## Android Google Play Release

Google Play release builds for Yelena Inventory must include the Supabase
configuration at compile time. Do not build Google Play AABs with a plain:

```powershell
flutter build appbundle --release
```

Set the required environment variables in PowerShell:

```powershell
$env:SUPABASE_URL = "https://your-project.supabase.co"
$env:SUPABASE_PUBLISHABLE_KEY = "your-supabase-publishable-key"
```

Then run the repeatable release script from the repository root:

```powershell
.\scripts\build_android_release.ps1
```

The generated AAB is written to:

```text
yelena_inventory/build/app/outputs/bundle/release/app-release.aab
```

The script fails before building if either Supabase value is missing. Secrets
must stay outside the repository.
