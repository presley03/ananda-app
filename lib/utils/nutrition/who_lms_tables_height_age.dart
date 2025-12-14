import 'who_lms_data.dart';

/// WHO Child Growth Standards - HEIGHT-FOR-AGE (PB/U or TB/U)
/// Panjang Badan (PB) untuk anak < 24 bulan (diukur berbaring)
/// Tinggi Badan (TB) untuk anak ≥ 24 bulan (diukur berdiri)
/// 
/// Source: WHO (2006) https://www.who.int/tools/child-growth-standards
class WhoLmsTablesHeightAge {
  
  // ============================================================================
  // HEIGHT-FOR-AGE (PB/U or TB/U) - BOYS (Laki-laki)
  // Unit: cm (sentimeter)
  // ============================================================================
  static const Map<int, WhoLmsData> heightForAgeBoys = {
    0: WhoLmsData(l: 1.0000, m: 49.8842, s: 0.03795),
    1: WhoLmsData(l: 1.0000, m: 54.7244, s: 0.03557),
    2: WhoLmsData(l: 1.0000, m: 58.4249, s: 0.03424),
    3: WhoLmsData(l: 1.0000, m: 61.4292, s: 0.03328),
    4: WhoLmsData(l: 1.0000, m: 63.8861, s: 0.03257),
    5: WhoLmsData(l: 1.0000, m: 65.9026, s: 0.03204),
    6: WhoLmsData(l: 1.0000, m: 67.6236, s: 0.03165),
    7: WhoLmsData(l: 1.0000, m: 69.1645, s: 0.03139),
    8: WhoLmsData(l: 1.0000, m: 70.5994, s: 0.03124),
    9: WhoLmsData(l: 1.0000, m: 71.9687, s: 0.03117),
    10: WhoLmsData(l: 1.0000, m: 73.2812, s: 0.03118),
    11: WhoLmsData(l: 1.0000, m: 74.5388, s: 0.03125),
    12: WhoLmsData(l: 1.0000, m: 75.7488, s: 0.03137),
    13: WhoLmsData(l: 1.0000, m: 76.9186, s: 0.03154),
    14: WhoLmsData(l: 1.0000, m: 78.0497, s: 0.03174),
    15: WhoLmsData(l: 1.0000, m: 79.1458, s: 0.03197),
    16: WhoLmsData(l: 1.0000, m: 80.2113, s: 0.03222),
    17: WhoLmsData(l: 1.0000, m: 81.2487, s: 0.03248),
    18: WhoLmsData(l: 1.0000, m: 82.2587, s: 0.03276),
    19: WhoLmsData(l: 1.0000, m: 83.2418, s: 0.03304),
    20: WhoLmsData(l: 1.0000, m: 84.1996, s: 0.03333),
    21: WhoLmsData(l: 1.0000, m: 85.1348, s: 0.03362),
    22: WhoLmsData(l: 1.0000, m: 86.0477, s: 0.03391),
    23: WhoLmsData(l: 1.0000, m: 86.9408, s: 0.03420),
    24: WhoLmsData(l: 1.0000, m: 87.8161, s: 0.03450),
    25: WhoLmsData(l: 1.0000, m: 88.6753, s: 0.03479),
    26: WhoLmsData(l: 1.0000, m: 89.5188, s: 0.03508),
    27: WhoLmsData(l: 1.0000, m: 90.3479, s: 0.03537),
    28: WhoLmsData(l: 1.0000, m: 91.1628, s: 0.03566),
    29: WhoLmsData(l: 1.0000, m: 91.9639, s: 0.03595),
    30: WhoLmsData(l: 1.0000, m: 92.7525, s: 0.03623),
    31: WhoLmsData(l: 1.0000, m: 93.5288, s: 0.03651),
    32: WhoLmsData(l: 1.0000, m: 94.2936, s: 0.03679),
    33: WhoLmsData(l: 1.0000, m: 95.0476, s: 0.03707),
    34: WhoLmsData(l: 1.0000, m: 95.7917, s: 0.03734),
    35: WhoLmsData(l: 1.0000, m: 96.5266, s: 0.03762),
    36: WhoLmsData(l: 1.0000, m: 97.2528, s: 0.03789),
    37: WhoLmsData(l: 1.0000, m: 97.9710, s: 0.03816),
    38: WhoLmsData(l: 1.0000, m: 98.6816, s: 0.03843),
    39: WhoLmsData(l: 1.0000, m: 99.3855, s: 0.03869),
    40: WhoLmsData(l: 1.0000, m: 100.0833, s: 0.03895),
    41: WhoLmsData(l: 1.0000, m: 100.7752, s: 0.03921),
    42: WhoLmsData(l: 1.0000, m: 101.4620, s: 0.03947),
    43: WhoLmsData(l: 1.0000, m: 102.1438, s: 0.03973),
    44: WhoLmsData(l: 1.0000, m: 102.8211, s: 0.03998),
    45: WhoLmsData(l: 1.0000, m: 103.4944, s: 0.04024),
    46: WhoLmsData(l: 1.0000, m: 104.1637, s: 0.04049),
    47: WhoLmsData(l: 1.0000, m: 104.8296, s: 0.04074),
    48: WhoLmsData(l: 1.0000, m: 105.4920, s: 0.04098),
    49: WhoLmsData(l: 1.0000, m: 106.1514, s: 0.04123),
    50: WhoLmsData(l: 1.0000, m: 106.8077, s: 0.04148),
    51: WhoLmsData(l: 1.0000, m: 107.4614, s: 0.04172),
    52: WhoLmsData(l: 1.0000, m: 108.1124, s: 0.04196),
    53: WhoLmsData(l: 1.0000, m: 108.7610, s: 0.04220),
    54: WhoLmsData(l: 1.0000, m: 109.4074, s: 0.04244),
    55: WhoLmsData(l: 1.0000, m: 110.0514, s: 0.04268),
    56: WhoLmsData(l: 1.0000, m: 110.6933, s: 0.04292),
    57: WhoLmsData(l: 1.0000, m: 111.3331, s: 0.04315),
    58: WhoLmsData(l: 1.0000, m: 111.9710, s: 0.04339),
    59: WhoLmsData(l: 1.0000, m: 112.6068, s: 0.04362),
    60: WhoLmsData(l: 1.0000, m: 113.2407, s: 0.04386),
  };

  // ============================================================================
  // HEIGHT-FOR-AGE (PB/U or TB/U) - GIRLS (Perempuan)
  // Unit: cm (sentimeter)
  // ============================================================================
  static const Map<int, WhoLmsData> heightForAgeGirls = {
    0: WhoLmsData(l: 1.0000, m: 49.1477, s: 0.03790),
    1: WhoLmsData(l: 1.0000, m: 53.6872, s: 0.03542),
    2: WhoLmsData(l: 1.0000, m: 57.0673, s: 0.03399),
    3: WhoLmsData(l: 1.0000, m: 59.8029, s: 0.03295),
    4: WhoLmsData(l: 1.0000, m: 62.0899, s: 0.03218),
    5: WhoLmsData(l: 1.0000, m: 64.0301, s: 0.03160),
    6: WhoLmsData(l: 1.0000, m: 65.7311, s: 0.03117),
    7: WhoLmsData(l: 1.0000, m: 67.2873, s: 0.03088),
    8: WhoLmsData(l: 1.0000, m: 68.7498, s: 0.03070),
    9: WhoLmsData(l: 1.0000, m: 70.1435, s: 0.03061),
    10: WhoLmsData(l: 1.0000, m: 71.4818, s: 0.03060),
    11: WhoLmsData(l: 1.0000, m: 72.7711, s: 0.03066),
    12: WhoLmsData(l: 1.0000, m: 74.0151, s: 0.03078),
    13: WhoLmsData(l: 1.0000, m: 75.2176, s: 0.03095),
    14: WhoLmsData(l: 1.0000, m: 76.3817, s: 0.03116),
    15: WhoLmsData(l: 1.0000, m: 77.5099, s: 0.03140),
    16: WhoLmsData(l: 1.0000, m: 78.6055, s: 0.03168),
    17: WhoLmsData(l: 1.0000, m: 79.6711, s: 0.03197),
    18: WhoLmsData(l: 1.0000, m: 80.7079, s: 0.03229),
    19: WhoLmsData(l: 1.0000, m: 81.7182, s: 0.03262),
    20: WhoLmsData(l: 1.0000, m: 82.7036, s: 0.03296),
    21: WhoLmsData(l: 1.0000, m: 83.6654, s: 0.03331),
    22: WhoLmsData(l: 1.0000, m: 84.6045, s: 0.03367),
    23: WhoLmsData(l: 1.0000, m: 85.5222, s: 0.03403),
    24: WhoLmsData(l: 1.0000, m: 86.4194, s: 0.03440),
    25: WhoLmsData(l: 1.0000, m: 87.2968, s: 0.03477),
    26: WhoLmsData(l: 1.0000, m: 88.1555, s: 0.03514),
    27: WhoLmsData(l: 1.0000, m: 88.9964, s: 0.03551),
    28: WhoLmsData(l: 1.0000, m: 89.8200, s: 0.03588),
    29: WhoLmsData(l: 1.0000, m: 90.6274, s: 0.03625),
    30: WhoLmsData(l: 1.0000, m: 91.4188, s: 0.03662),
    31: WhoLmsData(l: 1.0000, m: 92.1955, s: 0.03699),
    32: WhoLmsData(l: 1.0000, m: 92.9575, s: 0.03736),
    33: WhoLmsData(l: 1.0000, m: 93.7057, s: 0.03772),
    34: WhoLmsData(l: 1.0000, m: 94.4407, s: 0.03809),
    35: WhoLmsData(l: 1.0000, m: 95.1631, s: 0.03845),
    36: WhoLmsData(l: 1.0000, m: 95.8732, s: 0.03881),
    37: WhoLmsData(l: 1.0000, m: 96.5718, s: 0.03917),
    38: WhoLmsData(l: 1.0000, m: 97.2593, s: 0.03953),
    39: WhoLmsData(l: 1.0000, m: 97.9361, s: 0.03988),
    40: WhoLmsData(l: 1.0000, m: 98.6026, s: 0.04024),
    41: WhoLmsData(l: 1.0000, m: 99.2593, s: 0.04059),
    42: WhoLmsData(l: 1.0000, m: 99.9065, s: 0.04094),
    43: WhoLmsData(l: 1.0000, m: 100.5445, s: 0.04129),
    44: WhoLmsData(l: 1.0000, m: 101.1739, s: 0.04163),
    45: WhoLmsData(l: 1.0000, m: 101.7948, s: 0.04198),
    46: WhoLmsData(l: 1.0000, m: 102.4076, s: 0.04232),
    47: WhoLmsData(l: 1.0000, m: 103.0127, s: 0.04266),
    48: WhoLmsData(l: 1.0000, m: 103.6101, s: 0.04300),
    49: WhoLmsData(l: 1.0000, m: 104.2003, s: 0.04334),
    50: WhoLmsData(l: 1.0000, m: 104.7834, s: 0.04368),
    51: WhoLmsData(l: 1.0000, m: 105.3595, s: 0.04401),
    52: WhoLmsData(l: 1.0000, m: 105.9291, s: 0.04435),
    53: WhoLmsData(l: 1.0000, m: 106.4921, s: 0.04468),
    54: WhoLmsData(l: 1.0000, m: 107.0490, s: 0.04501),
    55: WhoLmsData(l: 1.0000, m: 107.5997, s: 0.04534),
    56: WhoLmsData(l: 1.0000, m: 108.1446, s: 0.04567),
    57: WhoLmsData(l: 1.0000, m: 108.6838, s: 0.04599),
    58: WhoLmsData(l: 1.0000, m: 109.2174, s: 0.04632),
    59: WhoLmsData(l: 1.0000, m: 109.7457, s: 0.04664),
    60: WhoLmsData(l: 1.0000, m: 110.2687, s: 0.04696),
  };

  /// Get height-for-age reference data
  static WhoLmsData? getHeightForAge(int ageMonths, String gender) {
    if (ageMonths < 0 || ageMonths > 60) return null;
    
    if (gender == 'L') {
      return heightForAgeBoys[ageMonths];
    } else {
      return heightForAgeGirls[ageMonths];
    }
  }
}
