import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';

/// Simple Card Option C - Soft Tinted
/// 
/// Characteristics:
/// - Soft color background (respects tintColor)
/// - Small shadow for subtle depth
/// - Gentle border
/// - Balance between beauty and performance
/// 
/// Performance: Good (light shadow only)
/// Use case: Balanced approach - visually appealing yet performant
/// 
/// Usage:
/// ```dart
/// SimpleCardOptionC(
///   child: Text('Content'),
///   tintColor: AppColors.category01Tint, // Uses soft tint
/// )
/// ```
class SimpleCardOptionC extends StatelessWidget {
  final Widget child;
  final Color? tintColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  
  const SimpleCardOptionC({
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
    // Use tint color or default to very soft white
    final backgroundColor = tintColor ?? Colors.white;
    
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        // Soft tinted background
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusL,
        ),
        // Gentle border
        border: Border.all(
          color: AppColors.textHint.withValues(alpha: 0.08),
          width: 1,
        ),
        // Small shadow for subtle depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
