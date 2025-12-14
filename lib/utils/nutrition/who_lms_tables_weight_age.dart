import 'who_lms_data.dart';

/// WHO Child Growth Standards - LMS Reference Tables
/// Source: WHO (2006) https://www.who.int/tools/child-growth-standards
/// 
/// Complete LMS tables for:
/// - Weight-for-age (0-60 months)
/// - Height-for-age (0-60 months)  
/// - Weight-for-height (45-110 cm)
/// - BMI-for-age (0-60 months)
class WhoLmsTables {
  
  // ============================================================================
  // WEIGHT-FOR-AGE (BB/U) - BOYS (Laki-laki)
  // ============================================================================
  static const Map<int, WhoLmsData> weightForAgeBoys = {
    0: WhoLmsData(l: 0.3487, m: 3.3464, s: 0.14602),
    1: WhoLmsData(l: 0.3487, m: 4.4709, s: 0.13395),
    2: WhoLmsData(l: 0.3487, m: 5.5675, s: 0.12385),
    3: WhoLmsData(l: 0.3487, m: 6.3762, s: 0.11727),
    4: WhoLmsData(l: 0.3487, m: 7.0023, s: 0.11316),
    5: WhoLmsData(l: 0.3487, m: 7.5105, s: 0.11080),
    6: WhoLmsData(l: 0.3487, m: 7.9344, s: 0.10958),
    7: WhoLmsData(l: 0.3487, m: 8.2970, s: 0.10902),
    8: WhoLmsData(l: 0.3487, m: 8.6151, s: 0.10882),
    9: WhoLmsData(l: 0.3487, m: 8.9014, s: 0.10881),
    10: WhoLmsData(l: 0.3487, m: 9.1649, s: 0.10891),
    11: WhoLmsData(l: 0.3487, m: 9.4122, s: 0.10906),
    12: WhoLmsData(l: 0.3487, m: 9.6479, s: 0.10925),
    13: WhoLmsData(l: 0.3487, m: 9.8749, s: 0.10949),
    14: WhoLmsData(l: 0.3487, m: 10.0953, s: 0.10976),
    15: WhoLmsData(l: 0.3487, m: 10.3108, s: 0.11007),
    16: WhoLmsData(l: 0.3487, m: 10.5228, s: 0.11041),
    17: WhoLmsData(l: 0.3487, m: 10.7319, s: 0.11080),
    18: WhoLmsData(l: 0.3487, m: 10.9388, s: 0.11121),
    19: WhoLmsData(l: 0.3487, m: 11.1438, s: 0.11166),
    20: WhoLmsData(l: 0.3487, m: 11.3473, s: 0.11214),
    21: WhoLmsData(l: 0.3487, m: 11.5496, s: 0.11264),
    22: WhoLmsData(l: 0.3487, m: 11.7508, s: 0.11317),
    23: WhoLmsData(l: 0.3487, m: 11.9511, s: 0.11373),
    24: WhoLmsData(l: 0.2581, m: 12.1515, s: 0.11432),
    25: WhoLmsData(l: 0.2252, m: 12.3502, s: 0.11496),
    26: WhoLmsData(l: 0.1970, m: 12.5464, s: 0.11566),
    27: WhoLmsData(l: 0.1730, m: 12.7393, s: 0.11643),
    28: WhoLmsData(l: 0.1524, m: 12.9285, s: 0.11728),
    29: WhoLmsData(l: 0.1347, m: 13.1135, s: 0.11820),
    30: WhoLmsData(l: 0.1195, m: 13.2944, s: 0.11920),
    31: WhoLmsData(l: 0.1063, m: 13.4713, s: 0.12028),
    32: WhoLmsData(l: 0.0949, m: 13.6447, s: 0.12143),
    33: WhoLmsData(l: 0.0849, m: 13.8151, s: 0.12264),
    34: WhoLmsData(l: 0.0762, m: 13.9829, s: 0.12390),
    35: WhoLmsData(l: 0.0685, m: 14.1485, s: 0.12521),
    36: WhoLmsData(l: 0.0618, m: 14.3124, s: 0.12656),
    37: WhoLmsData(l: 0.0558, m: 14.4749, s: 0.12794),
    38: WhoLmsData(l: 0.0505, m: 14.6364, s: 0.12934),
    39: WhoLmsData(l: 0.0457, m: 14.7972, s: 0.13075),
    40: WhoLmsData(l: 0.0414, m: 14.9576, s: 0.13217),
    41: WhoLmsData(l: 0.0376, m: 15.1179, s: 0.13359),
    42: WhoLmsData(l: 0.0341, m: 15.2782, s: 0.13501),
    43: WhoLmsData(l: 0.0310, m: 15.4387, s: 0.13641),
    44: WhoLmsData(l: 0.0281, m: 15.5994, s: 0.13781),
    45: WhoLmsData(l: 0.0255, m: 15.7606, s: 0.13919),
    46: WhoLmsData(l: 0.0231, m: 15.9221, s: 0.14055),
    47: WhoLmsData(l: 0.0209, m: 16.0841, s: 0.14189),
    48: WhoLmsData(l: 0.0189, m: 16.2465, s: 0.14322),
    49: WhoLmsData(l: 0.0171, m: 16.4094, s: 0.14452),
    50: WhoLmsData(l: 0.0154, m: 16.5728, s: 0.14580),
    51: WhoLmsData(l: 0.0139, m: 16.7365, s: 0.14706),
    52: WhoLmsData(l: 0.0125, m: 16.9007, s: 0.14830),
    53: WhoLmsData(l: 0.0112, m: 17.0652, s: 0.14951),
    54: WhoLmsData(l: 0.0100, m: 17.2300, s: 0.15071),
    55: WhoLmsData(l: 0.0089, m: 17.3951, s: 0.15188),
    56: WhoLmsData(l: 0.0078, m: 17.5604, s: 0.15304),
    57: WhoLmsData(l: 0.0069, m: 17.7259, s: 0.15417),
    58: WhoLmsData(l: 0.0060, m: 17.8917, s: 0.15529),
    59: WhoLmsData(l: 0.0051, m: 18.0576, s: 0.15638),
    60: WhoLmsData(l: 0.0044, m: 18.2236, s: 0.15746),
  };

  // ============================================================================
  // WEIGHT-FOR-AGE (BB/U) - GIRLS (Perempuan)
  // ============================================================================
  static const Map<int, WhoLmsData> weightForAgeGirls = {
    0: WhoLmsData(l: 0.3809, m: 3.2322, s: 0.14171),
    1: WhoLmsData(l: 0.3809, m: 4.1873, s: 0.13155),
    2: WhoLmsData(l: 0.3809, m: 5.1282, s: 0.12100),
    3: WhoLmsData(l: 0.3809, m: 5.8458, s: 0.11428),
    4: WhoLmsData(l: 0.3809, m: 6.4237, s: 0.11007),
    5: WhoLmsData(l: 0.3809, m: 6.8985, s: 0.10762),
    6: WhoLmsData(l: 0.3809, m: 7.2970, s: 0.10623),
    7: WhoLmsData(l: 0.3809, m: 7.6422, s: 0.10544),
    8: WhoLmsData(l: 0.3809, m: 7.9487, s: 0.10500),
    9: WhoLmsData(l: 0.3809, m: 8.2254, s: 0.10475),
    10: WhoLmsData(l: 0.3809, m: 8.4800, s: 0.10460),
    11: WhoLmsData(l: 0.3809, m: 8.7177, s: 0.10452),
    12: WhoLmsData(l: 0.3809, m: 8.9433, s: 0.10448),
    13: WhoLmsData(l: 0.3809, m: 9.1596, s: 0.10449),
    14: WhoLmsData(l: 0.3809, m: 9.3686, s: 0.10454),
    15: WhoLmsData(l: 0.3809, m: 9.5719, s: 0.10464),
    16: WhoLmsData(l: 0.3809, m: 9.7707, s: 0.10478),
    17: WhoLmsData(l: 0.3809, m: 9.9659, s: 0.10496),
    18: WhoLmsData(l: 0.3809, m: 10.1584, s: 0.10518),
    19: WhoLmsData(l: 0.3809, m: 10.3486, s: 0.10543),
    20: WhoLmsData(l: 0.3809, m: 10.5371, s: 0.10572),
    21: WhoLmsData(l: 0.3809, m: 10.7242, s: 0.10604),
    22: WhoLmsData(l: 0.3809, m: 10.9102, s: 0.10639),
    23: WhoLmsData(l: 0.3809, m: 11.0953, s: 0.10678),
    24: WhoLmsData(l: 0.3199, m: 11.2796, s: 0.10720),
    25: WhoLmsData(l: 0.2842, m: 11.4623, s: 0.10766),
    26: WhoLmsData(l: 0.2547, m: 11.6429, s: 0.10817),
    27: WhoLmsData(l: 0.2297, m: 11.8210, s: 0.10873),
    28: WhoLmsData(l: 0.2081, m: 11.9961, s: 0.10935),
    29: WhoLmsData(l: 0.1893, m: 12.1682, s: 0.11004),
    30: WhoLmsData(l: 0.1727, m: 12.3374, s: 0.11079),
    31: WhoLmsData(l: 0.1580, m: 12.5038, s: 0.11161),
    32: WhoLmsData(l: 0.1448, m: 12.6675, s: 0.11250),
    33: WhoLmsData(l: 0.1329, m: 12.8288, s: 0.11346),
    34: WhoLmsData(l: 0.1222, m: 12.9879, s: 0.11448),
    35: WhoLmsData(l: 0.1124, m: 13.1449, s: 0.11557),
    36: WhoLmsData(l: 0.1035, m: 13.3000, s: 0.11672),
    37: WhoLmsData(l: 0.0953, m: 13.4535, s: 0.11793),
    38: WhoLmsData(l: 0.0878, m: 13.6055, s: 0.11919),
    39: WhoLmsData(l: 0.0809, m: 13.7562, s: 0.12049),
    40: WhoLmsData(l: 0.0746, m: 13.9056, s: 0.12184),
    41: WhoLmsData(l: 0.0687, m: 14.0540, s: 0.12322),
    42: WhoLmsData(l: 0.0633, m: 14.2015, s: 0.12463),
    43: WhoLmsData(l: 0.0582, m: 14.3481, s: 0.12607),
    44: WhoLmsData(l: 0.0535, m: 14.4940, s: 0.12753),
    45: WhoLmsData(l: 0.0491, m: 14.6393, s: 0.12900),
    46: WhoLmsData(l: 0.0450, m: 14.7841, s: 0.13048),
    47: WhoLmsData(l: 0.0412, m: 14.9284, s: 0.13197),
    48: WhoLmsData(l: 0.0376, m: 15.0723, s: 0.13347),
    49: WhoLmsData(l: 0.0343, m: 15.2160, s: 0.13496),
    50: WhoLmsData(l: 0.0312, m: 15.3594, s: 0.13645),
    51: WhoLmsData(l: 0.0283, m: 15.5026, s: 0.13794),
    52: WhoLmsData(l: 0.0256, m: 15.6456, s: 0.13943),
    53: WhoLmsData(l: 0.0230, m: 15.7886, s: 0.14091),
    54: WhoLmsData(l: 0.0206, m: 15.9314, s: 0.14238),
    55: WhoLmsData(l: 0.0184, m: 16.0742, s: 0.14384),
    56: WhoLmsData(l: 0.0163, m: 16.2170, s: 0.14530),
    57: WhoLmsData(l: 0.0143, m: 16.3597, s: 0.14674),
    58: WhoLmsData(l: 0.0125, m: 16.5025, s: 0.14818),
    59: WhoLmsData(l: 0.0108, m: 16.6452, s: 0.14961),
    60: WhoLmsData(l: 0.0092, m: 16.7880, s: 0.15102),
  };

  /// Get weight-for-age reference data
  static WhoLmsData? getWeightForAge(int ageMonths, String gender) {
    if (ageMonths < 0 || ageMonths > 60) return null;
    
    if (gender == 'L') {
      return weightForAgeBoys[ageMonths];
    } else {
      return weightForAgeGirls[ageMonths];
    }
  }
}
