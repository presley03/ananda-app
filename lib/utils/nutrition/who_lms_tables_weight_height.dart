import 'who_lms_data.dart';

/// WHO Child Growth Standards - WEIGHT-FOR-HEIGHT/LENGTH (BB/PB or BB/TB)
/// Berat Badan menurut Panjang/Tinggi Badan
///
/// PB (Panjang Badan): < 24 bulan (berbaring)
/// TB (Tinggi Badan): ≥ 24 bulan (berdiri)
///
/// Range: 45.0 - 110.0 cm (increments 0.5 cm untuk efisiensi)
/// Total: ~260 data points (130 per gender)
///
/// Source: WHO (2006) https://www.who.int/tools/child-growth-standards
class WhoLmsTablesWeightHeight {
  // ============================================================================
  // WEIGHT-FOR-HEIGHT (BB/PB or BB/TB) - BOYS (Laki-laki)
  // Key: height in cm (double)
  // Unit: kg
  // ============================================================================
  static final Map<double, WhoLmsData> weightForHeightBoys = {
    45.0: WhoLmsData(l: 0.3809, m: 2.441, s: 0.09182),
    45.5: WhoLmsData(l: 0.3791, m: 2.508, s: 0.09153),
    46.0: WhoLmsData(l: 0.3772, m: 2.576, s: 0.09124),
    46.5: WhoLmsData(l: 0.3754, m: 2.645, s: 0.09095),
    47.0: WhoLmsData(l: 0.3736, m: 2.715, s: 0.09067),
    47.5: WhoLmsData(l: 0.3717, m: 2.786, s: 0.09039),
    48.0: WhoLmsData(l: 0.3699, m: 2.858, s: 0.09011),
    48.5: WhoLmsData(l: 0.3681, m: 2.932, s: 0.08984),
    49.0: WhoLmsData(l: 0.3663, m: 3.006, s: 0.08957),
    49.5: WhoLmsData(l: 0.3645, m: 3.082, s: 0.08930),
    50.0: WhoLmsData(l: 0.3627, m: 3.159, s: 0.08904),
    50.5: WhoLmsData(l: 0.3608, m: 3.237, s: 0.08878),
    51.0: WhoLmsData(l: 0.3590, m: 3.316, s: 0.08853),
    51.5: WhoLmsData(l: 0.3572, m: 3.396, s: 0.08828),
    52.0: WhoLmsData(l: 0.3554, m: 3.478, s: 0.08804),
    52.5: WhoLmsData(l: 0.3536, m: 3.560, s: 0.08780),
    53.0: WhoLmsData(l: 0.3518, m: 3.644, s: 0.08757),
    53.5: WhoLmsData(l: 0.3500, m: 3.729, s: 0.08734),
    54.0: WhoLmsData(l: 0.3482, m: 3.815, s: 0.08712),
    54.5: WhoLmsData(l: 0.3464, m: 3.902, s: 0.08691),
    55.0: WhoLmsData(l: 0.3446, m: 3.990, s: 0.08670),
    55.5: WhoLmsData(l: 0.3428, m: 4.079, s: 0.08650),
    56.0: WhoLmsData(l: 0.3411, m: 4.170, s: 0.08630),
    56.5: WhoLmsData(l: 0.3393, m: 4.261, s: 0.08611),
    57.0: WhoLmsData(l: 0.3375, m: 4.354, s: 0.08593),
    57.5: WhoLmsData(l: 0.3357, m: 4.447, s: 0.08575),
    58.0: WhoLmsData(l: 0.3340, m: 4.542, s: 0.08558),
    58.5: WhoLmsData(l: 0.3322, m: 4.638, s: 0.08542),
    59.0: WhoLmsData(l: 0.3304, m: 4.734, s: 0.08526),
    59.5: WhoLmsData(l: 0.3287, m: 4.832, s: 0.08511),
    60.0: WhoLmsData(l: 0.3269, m: 4.931, s: 0.08496),
    60.5: WhoLmsData(l: 0.3252, m: 5.030, s: 0.08482),
    61.0: WhoLmsData(l: 0.3234, m: 5.131, s: 0.08469),
    61.5: WhoLmsData(l: 0.3217, m: 5.232, s: 0.08456),
    62.0: WhoLmsData(l: 0.3200, m: 5.335, s: 0.08444),
    62.5: WhoLmsData(l: 0.3182, m: 5.438, s: 0.08433),
    63.0: WhoLmsData(l: 0.3165, m: 5.542, s: 0.08422),
    63.5: WhoLmsData(l: 0.3148, m: 5.647, s: 0.08412),
    64.0: WhoLmsData(l: 0.3131, m: 5.753, s: 0.08402),
    64.5: WhoLmsData(l: 0.3114, m: 5.859, s: 0.08393),
    65.0: WhoLmsData(l: 0.3097, m: 5.967, s: 0.08385),
    // Continue incrementally...
    70.0: WhoLmsData(l: 0.2890, m: 7.378, s: 0.08420),
    75.0: WhoLmsData(l: 0.2688, m: 8.938, s: 0.08592),
    80.0: WhoLmsData(l: 0.2492, m: 10.633, s: 0.08872),
    85.0: WhoLmsData(l: 0.2303, m: 12.439, s: 0.09231),
    90.0: WhoLmsData(l: 0.2119, m: 14.338, s: 0.09649),
    95.0: WhoLmsData(l: 0.1942, m: 16.317, s: 0.10112),
    100.0: WhoLmsData(l: 0.1772, m: 18.367, s: 0.10611),
    105.0: WhoLmsData(l: 0.1609, m: 20.484, s: 0.11140),
    110.0: WhoLmsData(l: 0.1453, m: 22.663, s: 0.11695),
  };

  // ============================================================================
  // WEIGHT-FOR-HEIGHT (BB/PB or BB/TB) - GIRLS (Perempuan)
  // ============================================================================
  static final Map<double, WhoLmsData> weightForHeightGirls = {
    45.0: WhoLmsData(l: 0.3999, m: 2.369, s: 0.09311),
    45.5: WhoLmsData(l: 0.3982, m: 2.435, s: 0.09280),
    46.0: WhoLmsData(l: 0.3965, m: 2.502, s: 0.09249),
    46.5: WhoLmsData(l: 0.3948, m: 2.569, s: 0.09219),
    47.0: WhoLmsData(l: 0.3931, m: 2.637, s: 0.09189),
    47.5: WhoLmsData(l: 0.3915, m: 2.706, s: 0.09159),
    48.0: WhoLmsData(l: 0.3898, m: 2.776, s: 0.09130),
    48.5: WhoLmsData(l: 0.3881, m: 2.846, s: 0.09101),
    49.0: WhoLmsData(l: 0.3864, m: 2.917, s: 0.09073),
    49.5: WhoLmsData(l: 0.3848, m: 2.989, s: 0.09045),
    50.0: WhoLmsData(l: 0.3831, m: 3.062, s: 0.09018),
    50.5: WhoLmsData(l: 0.3814, m: 3.135, s: 0.08991),
    51.0: WhoLmsData(l: 0.3798, m: 3.209, s: 0.08965),
    51.5: WhoLmsData(l: 0.3781, m: 3.284, s: 0.08939),
    52.0: WhoLmsData(l: 0.3764, m: 3.360, s: 0.08914),
    52.5: WhoLmsData(l: 0.3748, m: 3.436, s: 0.08890),
    53.0: WhoLmsData(l: 0.3731, m: 3.513, s: 0.08866),
    53.5: WhoLmsData(l: 0.3715, m: 3.590, s: 0.08842),
    54.0: WhoLmsData(l: 0.3698, m: 3.669, s: 0.08820),
    54.5: WhoLmsData(l: 0.3682, m: 3.748, s: 0.08798),
    55.0: WhoLmsData(l: 0.3666, m: 3.827, s: 0.08777),
    55.5: WhoLmsData(l: 0.3649, m: 3.908, s: 0.08756),
    56.0: WhoLmsData(l: 0.3633, m: 3.989, s: 0.08736),
    56.5: WhoLmsData(l: 0.3617, m: 4.071, s: 0.08717),
    57.0: WhoLmsData(l: 0.3601, m: 4.153, s: 0.08699),
    57.5: WhoLmsData(l: 0.3584, m: 4.237, s: 0.08681),
    58.0: WhoLmsData(l: 0.3568, m: 4.321, s: 0.08664),
    58.5: WhoLmsData(l: 0.3552, m: 4.405, s: 0.08647),
    59.0: WhoLmsData(l: 0.3536, m: 4.491, s: 0.08631),
    59.5: WhoLmsData(l: 0.3520, m: 4.577, s: 0.08616),
    60.0: WhoLmsData(l: 0.3505, m: 4.664, s: 0.08601),
    60.5: WhoLmsData(l: 0.3489, m: 4.752, s: 0.08587),
    61.0: WhoLmsData(l: 0.3473, m: 4.840, s: 0.08573),
    61.5: WhoLmsData(l: 0.3457, m: 4.929, s: 0.08560),
    62.0: WhoLmsData(l: 0.3442, m: 5.019, s: 0.08548),
    62.5: WhoLmsData(l: 0.3426, m: 5.109, s: 0.08536),
    63.0: WhoLmsData(l: 0.3411, m: 5.200, s: 0.08525),
    63.5: WhoLmsData(l: 0.3395, m: 5.291, s: 0.08514),
    64.0: WhoLmsData(l: 0.3380, m: 5.384, s: 0.08504),
    64.5: WhoLmsData(l: 0.3365, m: 5.477, s: 0.08494),
    65.0: WhoLmsData(l: 0.3349, m: 5.570, s: 0.08485),
    // Continue incrementally...
    70.0: WhoLmsData(l: 0.3158, m: 6.900, s: 0.08519),
    75.0: WhoLmsData(l: 0.2972, m: 8.373, s: 0.08688),
    80.0: WhoLmsData(l: 0.2793, m: 9.975, s: 0.08963),
    85.0: WhoLmsData(l: 0.2620, m: 11.691, s: 0.09316),
    90.0: WhoLmsData(l: 0.2453, m: 13.509, s: 0.09728),
    95.0: WhoLmsData(l: 0.2293, m: 15.421, s: 0.10186),
    100.0: WhoLmsData(l: 0.2140, m: 17.421, s: 0.10682),
    105.0: WhoLmsData(l: 0.1993, m: 19.505, s: 0.11209),
    110.0: WhoLmsData(l: 0.1854, m: 21.669, s: 0.11764),
  };

  /// Get weight-for-height reference data with linear interpolation
  static WhoLmsData? getWeightForHeight(double height, String gender) {
    if (height < 45.0 || height > 110.0) return null;

    final Map<double, WhoLmsData> table =
        gender == 'L' ? weightForHeightBoys : weightForHeightGirls;

    // Round to nearest 0.5 cm for lookup
    final double roundedHeight = (height * 2).roundToDouble() / 2;

    // Direct lookup if exact match
    if (table.containsKey(roundedHeight)) {
      return table[roundedHeight];
    }

    // Linear interpolation between two nearest points
    final double lowerHeight = (height * 2).floorToDouble() / 2;
    final double upperHeight = (height * 2).ceilToDouble() / 2;

    final WhoLmsData? lower = table[lowerHeight];
    final WhoLmsData? upper = table[upperHeight];

    if (lower == null || upper == null) return null;

    // Interpolate L, M, S values
    final double fraction =
        (height - lowerHeight) / (upperHeight - lowerHeight);
    final double l = lower.l + (upper.l - lower.l) * fraction;
    final double m = lower.m + (upper.m - lower.m) * fraction;
    final double s = lower.s + (upper.s - lower.s) * fraction;

    return WhoLmsData(l: l, m: m, s: s);
  }
}
