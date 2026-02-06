
package io.anyline.flutter.nativeview;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.PixelFormat;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

public class NativeFragmentContainerView implements PlatformView {
    private final FrameLayout container;
    private final String containerId;

    NativeFragmentContainerView(Context context, int id, Map<String, Object> args) {
        container = new FrameLayout(context);
        container.setLayoutParams(
                new WindowManager.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        WindowManager.LayoutParams.TYPE_APPLICATION,
                        WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
                        PixelFormat.TRANSLUCENT
                ));

        container.isHardwareAccelerated();

        container.setId(View.generateViewId());

        containerId = String.valueOf(container.getId());

        NativeViewRegistry.register(containerId, container);
    }

    @Override
    public View getView() {
        return container;
    }

    @Override
    public void dispose() {
        NativeViewRegistry.remove(containerId);
    }
}
