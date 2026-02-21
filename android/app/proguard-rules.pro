# Keep Razorpay and Google Pay classes
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
-keep class com.google.android.apps.nbu.paisa.** { *; }

# Keep ProGuard annotations
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keep @proguard.annotation.Keep class * { *; }
-keep @proguard.annotation.KeepClassMembers class * { *; }

# Suppress warnings
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
-dontwarn com.google.android.apps.nbu.paisa.**