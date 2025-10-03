# Anyline SDK ProGuard rules are automatically applied via consumer-proguard-rules.pro
# No manual Anyline rules needed when using SDK 55.5.0+

# Add your app-specific ProGuard rules here if needed

# The Anyline Mobile SDK for Android includes the following ProGuard rules:
#-keep public class io.anyline.plugin.config.** {
#  public protected *;
#}
#
#-keep public class io.anyline.plugin.result.** {
#  public protected *;
#}
#
#-keep class io.anyline.wrapper.config.** {
#  public protected *;
#}
#
#-keep public class io.anyline2.core.** {
#  public protected *;
#}
#
#-keep class at.nineyards.anyline.** { *; }
#-dontwarn at.nineyards.anyline.**
#
#-dontwarn com.squareup.moshi.**
#-keep class com.squareup.moshi.** { *; }
#-keepclassmembers class * {
#    @com.squareup.moshi.* <fields>;
#}
#-keep @com.squareup.moshi.JsonClass class * { *; }
#-keepclassmembers class kotlin.Metadata { *; }
#-dontwarn org.jetbrains.annotations.**
