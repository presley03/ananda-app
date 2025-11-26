import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';

/// Glass Card Widget
/// Reusable glassmorphism card dengan blur effect
/// 
/// Usage:
/// ```dart
/// GlassCard(
///   child: Text('Content'),
///   tintColor: AppColors.category01Tint,
/// )
/// ```
class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? tintColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  
  const GlassCard({
    Key? key,
    required this.child,
    this.tintColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: tintColor ?? AppColors.glassWhite,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusL,
        ),
        border: Border.all(
          color: AppColors.glassBorder,
          width: AppDimensions.borderWidthMedium,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppDimensions.elevationM,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusL,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppDimensions.blurSigma,
            sigmaY: AppDimensions.blurSigma,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusL,
        ),
        child: card,
      );
    }

    return card;
  }
}
