import 'package:anyline_plugin/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AnylineNativeView extends StatelessWidget {
  const AnylineNativeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: Constants.ANYLINE_NATIVE_VIEW_FACTORY_ID,
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: Constants.ANYLINE_NATIVE_VIEW_FACTORY_ID,
              layoutDirection: TextDirection.ltr,
              creationParams: {'id': 'scan-view-container-id'},
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      case TargetPlatform.iOS:
        return const Center(
          child: UiKitView(
            viewType: Constants.ANYLINE_NATIVE_VIEW_FACTORY_ID,
            creationParams: {'id': 'scan-view-container-id'},
            creationParamsCodec: StandardMessageCodec(),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
