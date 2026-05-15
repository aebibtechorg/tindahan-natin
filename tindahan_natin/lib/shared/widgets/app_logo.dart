import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget logo = Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (!showText) return logo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        SizedBox(width: size * 0.3),
        Text(
          'Tindahan Natin',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: size * 0.55,
            color: color ?? theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
