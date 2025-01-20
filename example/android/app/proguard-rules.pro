-keep public class io.anyline.plugin.config.** {
  public protected *;
}

-keep public class io.anyline.plugin.result.** {
  public protected *;
}

-keep public class io.anyline2.core.** {
  public protected *;
}

-keep class at.nineyards.anyline.** { *; }
-dontwarn at.nineyards.anyline.**
-keep class org.opencv.** { *; }
-dontwarn org.opencv.**

-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.plugins.** { *; }

-dontwarn com.squareup.moshi.**
-keep class com.squareup.moshi.** { *; }
-keepclassmembers class * {
    @com.squareup.moshi.* <fields>;
}
-keep @com.squareup.moshi.JsonClass class * { *; }
-keepclassmembers class kotlin.Metadata { *; }
-dontwarn org.jetbrains.annotations.**