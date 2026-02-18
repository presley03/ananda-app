import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';

/// Simple Card Option A - Material 3 Clean
/// 
/// Characteristics:
/// - Clean white background
/// - Soft shadow (elevation 2)
/// - Subtle border
/// - Modern & professional look
/// 
/// Performance: Good (no blur effect)
/// Use case: Professional medical app with clean aesthetic
/// 
/// Usage:
/// ```dart
/// SimpleCardOptionA(
///   child: Text('Content'),
///   tintColor: AppColors.category01Tint, // Optional tint
/// )
/// ```
class SimpleCardOptionA extends StatelessWidget {
  final Widget child;
  final Color? tintColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  
  const SimpleCardOptionA({
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
        // Subtle border for definition
        border: Border.all(
          color: AppColors.textHint.withValues(alpha: 0.1),
          width: 1,
        ),
        // Soft shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
