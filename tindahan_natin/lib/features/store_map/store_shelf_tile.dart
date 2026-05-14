import 'dart:math' as math;

import 'package:flutter/material.dart';

class StoreShelfTile extends StatelessWidget {
  const StoreShelfTile({
    super.key,
    required this.name,
    this.isDragging = false,
    this.isSelected = false,
    this.rotation = 0.0,
  });

  final String name;
  final bool isDragging;
  final bool isSelected;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? Colors.orange : Colors.blue;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 96, minHeight: 48),
      child: Transform.rotate(
        angle: rotation * math.pi / 180.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDragging ? backgroundColor.withValues(alpha: 0.6) : backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Material(
            color: Colors.transparent,
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}