import 'dart:math' as math;

/// WHO LMS (Lambda-Mu-Sigma) Reference Data Point
/// Used for calculating Z-scores using WHO Child Growth Standards
/// 
/// L = Box-Cox power transformation (skewness)
/// M = Median value
/// S = Coefficient of variation
class WhoLmsData {
  final double l; // Lambda (skewness)
  final double m; // Mu (median)
  final double s; // Sigma (coefficient of variation)

  const WhoLmsData({
    required this.l,
    required this.m,
    required this.s,
  });

  /// Calculate Z-score using LMS method
  /// Formula: Z = [(X/M)^L - 1] / (L × S)
  /// 
  /// Special case when L is very close to 0:
  /// Z = ln(X/M) / S
  double calculateZScore(double value) {
    if (l.abs() < 0.01) {
      // When L ≈ 0, use logarithmic formula
      return math.log(value / m) / s;
    }
    
    // Standard LMS formula
    return (math.pow(value / m, l) - 1) / (l * s);
  }

  /// Calculate value from Z-score (inverse)
  /// X = M × [(1 + L × S × Z)^(1/L)]
  double calculateValue(double zScore) {
    if (l.abs() < 0.01) {
      // When L ≈ 0
      return m * math.exp(s * zScore);
    }
    
    return m * math.pow(1 + l * s * zScore, 1 / l);
  }

  @override
  String toString() {
    return 'WhoLmsData(L: ${l.toStringAsFixed(4)}, M: ${m.toStringAsFixed(4)}, S: ${s.toStringAsFixed(5)})';
  }
}
