# Keep ML Kit and Firebase ComponentDiscovery registrars.
# ML Kit discovers these classes reflectively in release builds.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.firebase.components.ComponentRegistrar { *; }
-keep class * implements com.google.firebase.components.ComponentRegistrar { *; }
-keepattributes *Annotation*
