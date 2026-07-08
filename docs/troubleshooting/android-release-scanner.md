# Android Release Scanner Issue (Resolved)

## Summary

The Yelena Inventory barcode scanner worked correctly in local Flutter debug
builds but failed when the application was installed from Google Play Closed
Testing as a release AAB.

The failure was caused by Android release processing that prevented ML Kit
component registrars from being instantiated through Firebase
`ComponentDiscovery`. Adding explicit ProGuard keep rules for the relevant ML
Kit and Firebase components resolved the issue.

## Symptoms

- The scanner worked correctly with `flutter run` and debug APK builds.
- The scanner failed only after installation from Google Play Closed Testing
  using a release AAB.
- The problem occurred on multiple Android devices.
- Camera permission was granted successfully.
- The scanner screen displayed:

  ```text
  MobileScannerErrorCode.genericError
  ```

- The native exception included:

  ```text
  Attempt to invoke virtual method ... on a null object reference
  ```

Because the camera opened normally in debug builds and permission was granted
in release builds, the issue initially appeared to be related to scanner
initialization rather than camera availability.

## Investigation Timeline

1. Temporary diagnostics were added to the scanner screen so the complete
   `MobileScannerException` details could be viewed in the Google Play release.
2. The diagnostic output confirmed that the failure was not caused by a denied
   camera permission or an unsupported device.
3. The `MobileScannerController` lifecycle was hardened to avoid early starts,
   duplicate starts, reuse after disposal, and unsafe pause/resume behavior.
   This improved lifecycle safety but did not resolve the release-only failure.
4. Both `mobile_scanner` 7.2.0 and 7.1.4 were tested. Version 7.1.4 was pinned
   exactly to eliminate unexpected dependency changes, but the same native
   initialization error remained.
5. The installed application version was verified with ADB to confirm that the
   intended Google Play build was under test.
6. Android `logcat` was captured while manually opening the scanner in the
   installed release application.
7. The native stack trace revealed that ML Kit `ComponentDiscovery` could not
   construct its component registrar classes.
8. Release ProGuard configuration and explicit keep rules were added. A new
   release AAB was uploaded to Google Play Closed Testing and the scanner was
   verified successfully on real devices.

## Root Cause

Android `logcat` showed that ML Kit `ComponentDiscovery` failed to instantiate
the following registrar classes:

- `com.google.mlkit.common.internal.CommonComponentRegistrar`
- `com.google.mlkit.vision.barcode.internal.BarcodeRegistrar`
- `com.google.mlkit.vision.common.internal.VisionCommonRegistrar`

The failure appeared as:

```text
NoSuchMethodException(...<init>())
```

These registrars are discovered and created reflectively. In the affected
release build, the required constructors or classes were not preserved in a
form that `ComponentDiscovery` could instantiate. ML Kit therefore did not
initialize, leaving an internal scanner dependency null. `mobile_scanner`
subsequently surfaced the generic error and native null-reference exception.

The problem was in Android release configuration, not camera permission,
Flutter widget lifecycle, or device-specific camera behavior.

## Resolution

The final successful fix consisted of the following:

1. Added a release ProGuard configuration to
   `android/app/build.gradle.kts`.
2. Added `android/app/proguard-rules.pro`.
3. Added keep rules for ML Kit classes, internal ML Kit classes, Firebase
   `ComponentRegistrar` implementations, and annotation metadata:

   ```proguard
   -keep class com.google.mlkit.** { *; }
   -keep class com.google.android.gms.internal.mlkit_** { *; }
   -keep class com.google.firebase.components.ComponentRegistrar { *; }
   -keep class * implements com.google.firebase.components.ComponentRegistrar { *; }
   -keepattributes *Annotation*
   ```

4. Connected the rules to the release build:

   ```kotlin
   proguardFiles(
       getDefaultProguardFile("proguard-android-optimize.txt"),
       "proguard-rules.pro",
   )
   ```

5. Kept `mobile_scanner` pinned exactly to version `7.1.4`.
6. Kept the Android ML Kit configuration enabled in
   `android/gradle.properties`:

   ```properties
   dev.steenbakker.mobile_scanner.useUnbundled=true
   ```

7. Built and distributed a new release AAB through Google Play Closed Testing.

## Files Modified

The final successful fix modified these files:

- `yelena_inventory/android/app/build.gradle.kts`
  - Connected the release build to the default optimized ProGuard rules and
    the application-specific rules file.
- `yelena_inventory/android/app/proguard-rules.pro`
  - Added ML Kit and Firebase `ComponentDiscovery` keep rules.
- `yelena_inventory/pubspec.yaml`
  - Kept `mobile_scanner` pinned to `7.1.4` and incremented the successful test
    release to `0.3.0+8`.

The following existing configuration was intentionally retained:

- `yelena_inventory/android/gradle.properties`
  - Retained `dev.steenbakker.mobile_scanner.useUnbundled=true`.
- `yelena_inventory/lib/screens/barcode_scanner_screen.dart`
  - Retained the stable scanner lifecycle implementation and temporary
    diagnostic output used during investigation.

## Validation

The final configuration was validated with:

```text
flutter analyze
flutter build appbundle --release
```

Both commands completed successfully.

The resulting release was installed through Google Play Closed Testing. The
barcode scanner was then verified successfully on:

- Samsung S23
- POCO device

This release validation was essential because local debug builds did not
reproduce the failure.

## Lessons Learned

- Debug builds are not sufficient for validating Android scanner integrations.
- Always test the actual release AAB distributed through Google Play.
- Capture Android `logcat` before repeatedly changing Flutter code or scanner
  settings.
- A generic Flutter plugin error can hide a precise native initialization
  failure.
- `ComponentDiscovery` constructor failures usually indicate Android release
  configuration, shrinking, obfuscation, or reflection issues rather than a
  Flutter widget lifecycle problem.
- Verify the installed application version with ADB when comparing test
  releases.
- Keep scanner dependencies pinned while diagnosing release-only regressions.
- Revalidate these ProGuard rules and repeat Google Play release testing
  whenever ML Kit, CameraX, `mobile_scanner`, Flutter, or the Android Gradle
  Plugin is upgraded.
- Keep this document updated if the scanner dependency or Android release
  configuration changes.
