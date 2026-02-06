
package io.anyline.flutter.nativeview;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;
import java.util.Map;

public class NativeFragmentContainerFactory extends PlatformViewFactory {
    public NativeFragmentContainerFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new NativeFragmentContainerView(context, viewId, (Map<String, Object>) args);
    }
}
