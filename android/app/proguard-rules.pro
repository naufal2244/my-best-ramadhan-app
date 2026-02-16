## Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

## Google Sign In
-keep class com.google.android.gms.auth.** { *; }

## Ignore Play Store Split Install (Fix for R8 build error)
-dontwarn com.google.android.play.core.**
