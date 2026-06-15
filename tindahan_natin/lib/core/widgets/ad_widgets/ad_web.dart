import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/config/ad_config/ad_helper.dart';
import 'package:tindahan_natin/core/network/connectivity_provider.dart';
import 'package:web/web.dart' as web;

class InlineAdWidget extends ConsumerStatefulWidget {
  const InlineAdWidget({super.key});

  @override
  ConsumerState<InlineAdWidget> createState() => _InlineAdWidgetState();
}

class _InlineAdWidgetState extends ConsumerState<InlineAdWidget> {
  late String _viewType;
  static int _instanceCount = 0;

  @override
  void initState() {
    super.initState();
    final instanceId = ++_instanceCount;
    _viewType = 'adsense-unit-$instanceId';

    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final adUnitId = AdHelper.bannerAdUnitId;
      final parts = adUnitId.split('/');
      
      // Sanitize client ID: AdSense expects ca-pub-, but AdMob uses ca-app-pub-
      var client = parts[0];
      if (client.startsWith('ca-app-pub-')) {
        client = client.replaceFirst('ca-app-pub-', 'ca-pub-');
      }
      
      final slot = parts.length > 1 ? parts[1] : '';

      final container = web.document.createElement('div') as web.HTMLDivElement;
      container.style.width = '100%';
      container.style.height = '100%';
      container.style.display = 'flex';
      container.style.justifyContent = 'center';
      container.style.alignItems = 'center';

      final shadowRoot = container.attachShadow(web.ShadowRootInit(mode: 'open'));

      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.style.border = 'none';
      iframe.style.overflow = 'hidden';
      
      // We use srcdoc to host the AdSense code in a same-origin-like but isolated context.
      // This allows the AdSense script to find the 'ins' tag without Shadow DOM interference.
      iframe.setAttribute('srcdoc', '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { margin: 0; padding: 0; overflow: hidden; background: transparent; display: flex; justify-content: center; align-items: center; height: 100vh; }
  </style>
  <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=$client" crossorigin="anonymous"></script>
</head>
<body>
  <ins class="adsbygoogle"
       style="display:block;width:100%;height:100%;"
       data-ad-client="$client"
       data-ad-slot="$slot"
       data-ad-format="horizontal"
       data-full-width-responsive="true"></ins>
  <script>
    (adsbygoogle = window.adsbygoogle || []).push({});
  </script>
</body>
</html>
''');

      shadowRoot.append(iframe);
      return container;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);
    if (!isOnline) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        return SizedBox(
          width: width,
          height: 136, // 120px for ad + 16px padding
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: HtmlElementView(viewType: _viewType),
          ),
        );
      },
    );
  }
}
