package io.anyline.flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * Entry point registered by Flutter's plugin system.
 *
 * Registers all Anyline Flutter plugins so each handles its own MethodChannel
 * independently. Adding or removing a plugin here has no effect on the others.
 */
public class AnylinePluginRegistrant implements FlutterPlugin {

    private final AnylinePlugin anylinePlugin = new AnylinePlugin();
    private final AnylineInfinityPlugin anylineInfinityPlugin = new AnylineInfinityPlugin();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        anylinePlugin.onAttachedToEngine(binding);
        anylineInfinityPlugin.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        anylinePlugin.onDetachedFromEngine(binding);
        anylineInfinityPlugin.onDetachedFromEngine(binding);
    }
}