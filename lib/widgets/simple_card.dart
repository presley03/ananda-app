import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';

/// Simple Card - Flat Minimal Design
///
/// Characteristics:
/// - Clean white background
/// - Border only, NO shadow
/// - Lightest weight option
/// - Ultra minimalist
/// - Perfect for low-end devices
///
/// Performance: Excellent (no blur, no shadow rendering)
///
/// Replaces: GlassCard (removed backdrop blur effect)
///
/// Usage:
/// ```dart
/// SimpleCard(
///   child: Text('Content'),
///   tintColor: AppColors.category01Tint, // Optional tint
/// )
/// ```
class SimpleCard extends StatelessWidget {
  final Widget child;
  final Color? tintColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const SimpleCard({
    super.key,
    required this.child,
    this.tintColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        // White background (or tinted if provided)
        color: tintColor ?? Colors.white,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusL,
        ),
        // Border for card definition
        border: Border.all(
          color: AppColors.textHint.withValues(alpha: 0.15),
          width: 1.5,
        ),
        // NO shadow - pure flat design for maximum performance
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusL,
          ),
          child: card,
        ),
      );
    }

    return card;
  }
}
