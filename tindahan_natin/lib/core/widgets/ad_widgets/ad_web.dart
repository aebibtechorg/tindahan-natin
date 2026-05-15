import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:tindahan_natin/core/config/ad_config/ad_helper.dart';
import 'package:web/web.dart' as web;

class InlineAdWidget extends StatefulWidget {
  const InlineAdWidget({super.key});

  @override
  State<InlineAdWidget> createState() => _InlineAdWidgetState();
}

class _InlineAdWidgetState extends State<InlineAdWidget> {
  static const String _viewType = 'adsense-unit';
  static bool _registered = false;

  @override
  void initState() {
    super.initState();
    if (!_registered) {
      ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final element = web.document.createElement('div') as web.HTMLDivElement;
        element.style.width = '100%';
        element.style.height = '100px';
        element.style.minWidth = '320px';
        element.style.minHeight = '100px';
        element.style.textAlign = 'center';
        element.style.padding = '8px';
        element.style.boxSizing = 'border-box';
        element.id = 'adsense-unit-$viewId';

        final ins = web.document.createElement('ins') as web.HTMLModElement;
        ins.className = 'adsbygoogle';
        ins.style.display = 'block';
        ins.style.width = '100%';
        ins.style.height = '100%';
        ins.setAttribute('data-ad-client', AdHelper.bannerAdUnitId.split('/')[0]);
        ins.setAttribute('data-ad-slot', AdHelper.bannerAdUnitId.split('/')[1]);
        ins.setAttribute('data-ad-format', 'auto');
        ins.setAttribute('data-full-width-responsive', 'true');

        final script = web.document.createElement('script') as web.HTMLScriptElement;
        script.text = '''
          (function initAd() {
            var container = document.getElementById("adsense-unit-$viewId");
            if (!container) {
              window.setTimeout(initAd, 50);
              return;
            }

            var width = container.getBoundingClientRect().width;
            if (!width || width <= 0) {
              window.setTimeout(initAd, 50);
              return;
            }

            if (container.dataset.adInitialized === 'true') {
              return;
            }

            container.dataset.adInitialized = 'true';
            (adsbygoogle = window.adsbygoogle || []).push({});
          })();
        ''';

        element.appendChild(ins);
        element.appendChild(script);
        return element;
      });
      _registered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        return SizedBox(
          width: width,
          height: 100,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: HtmlElementView(viewType: _viewType),
          ),
        );
      },
    );
  }
}
