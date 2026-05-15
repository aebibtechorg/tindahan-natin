import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
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
        element.style.height = '100%';
        element.style.textAlign = 'center';
        element.style.padding = '8px';

        final ins = web.document.createElement('ins') as web.HTMLModElement;
        ins.className = 'adsbygoogle';
        ins.style.display = 'block';
        ins.setAttribute('data-ad-client', 'ca-pub-0000000000000000');
        ins.setAttribute('data-ad-slot', '0000000000');
        ins.setAttribute('data-ad-format', 'auto');
        ins.setAttribute('data-full-width-responsive', 'true');

        final script = web.document.createElement('script') as web.HTMLScriptElement;
        script.text = '(adsbygoogle = window.adsbygoogle || []).push({});';

        element.appendChild(ins);
        element.appendChild(script);
        return element;
      });
      _registered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const HtmlElementView(viewType: _viewType),
    );
  }
}
