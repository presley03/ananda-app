import 'who_lms_data.dart';

/// WHO Child Growth Standards - BMI-FOR-AGE (IMT/U)
/// Indeks Massa Tubuh menurut Umur
/// IMT = Berat (kg) / [Tinggi (m)]²
/// 
/// Source: WHO (2006) https://www.who.int/tools/child-growth-standards
class WhoLmsTablesBmiAge {
  
  // ============================================================================
  // BMI-FOR-AGE (IMT/U) - BOYS (Laki-laki)
  // Unit: kg/m²
  // ============================================================================
  static const Map<int, WhoLmsData> bmiForAgeBoys = {
    0: WhoLmsData(l: -1.6384, m: 13.4049, s: 0.08874),
    1: WhoLmsData(l: -1.6421, m: 16.1202, s: 0.08023),
    2: WhoLmsData(l: -1.6308, m: 17.3710, s: 0.07497),
    3: WhoLmsData(l: -1.6060, m: 17.8345, s: 0.07216),
    4: WhoLmsData(l: -1.5722, m: 17.9650, s: 0.07046),
    5: WhoLmsData(l: -1.5321, m: 17.9138, s: 0.06934),
    6: WhoLmsData(l: -1.4880, m: 17.7622, s: 0.06854),
    7: WhoLmsData(l: -1.4419, m: 17.5551, s: 0.06794),
    8: WhoLmsData(l: -1.3952, m: 17.3214, s: 0.06748),
    9: WhoLmsData(l: -1.3491, m: 17.0774, s: 0.06712),
    10: WhoLmsData(l: -1.3044, m: 16.8342, s: 0.06685),
    11: WhoLmsData(l: -1.2619, m: 16.6002, s: 0.06665),
    12: WhoLmsData(l: -1.2218, m: 16.3819, s: 0.06653),
    13: WhoLmsData(l: -1.1846, m: 16.1843, s: 0.06648),
    14: WhoLmsData(l: -1.1502, m: 16.0102, s: 0.06651),
    15: WhoLmsData(l: -1.1188, m: 15.8612, s: 0.06662),
    16: WhoLmsData(l: -1.0903, m: 15.7380, s: 0.06682),
    17: WhoLmsData(l: -1.0645, m: 15.6400, s: 0.06709),
    18: WhoLmsData(l: -1.0413, m: 15.5663, s: 0.06745),
    19: WhoLmsData(l: -1.0204, m: 15.5153, s: 0.06789),
    20: WhoLmsData(l: -1.0016, m: 15.4851, s: 0.06840),
    21: WhoLmsData(l: -0.9847, m: 15.4736, s: 0.06899),
    22: WhoLmsData(l: -0.9696, m: 15.4788, s: 0.06964),
    23: WhoLmsData(l: -0.9560, m: 15.4987, s: 0.07036),
    24: WhoLmsData(l: -0.9439, m: 15.5315, s: 0.07113),
    25: WhoLmsData(l: -0.9331, m: 15.5755, s: 0.07195),
    26: WhoLmsData(l: -0.9235, m: 15.6294, s: 0.07281),
    27: WhoLmsData(l: -0.9149, m: 15.6919, s: 0.07371),
    28: WhoLmsData(l: -0.9073, m: 15.7620, s: 0.07464),
    29: WhoLmsData(l: -0.9006, m: 15.8388, s: 0.07559),
    30: WhoLmsData(l: -0.8947, m: 15.9216, s: 0.07657),
    31: WhoLmsData(l: -0.8896, m: 16.0097, s: 0.07756),
    32: WhoLmsData(l: -0.8852, m: 16.1024, s: 0.07856),
    33: WhoLmsData(l: -0.8814, m: 16.1993, s: 0.07957),
    34: WhoLmsData(l: -0.8782, m: 16.2999, s: 0.08058),
    35: WhoLmsData(l: -0.8755, m: 16.4038, s: 0.08159),
    36: WhoLmsData(l: -0.8733, m: 16.5106, s: 0.08260),
    37: WhoLmsData(l: -0.8716, m: 16.6200, s: 0.08360),
    38: WhoLmsData(l: -0.8702, m: 16.7318, s: 0.08460),
    39: WhoLmsData(l: -0.8692, m: 16.8456, s: 0.08559),
    40: WhoLmsData(l: -0.8686, m: 16.9612, s: 0.08657),
    41: WhoLmsData(l: -0.8682, m: 17.0784, s: 0.08753),
    42: WhoLmsData(l: -0.8681, m: 17.1969, s: 0.08849),
    43: WhoLmsData(l: -0.8683, m: 17.3167, s: 0.08943),
    44: WhoLmsData(l: -0.8687, m: 17.4375, s: 0.09036),
    45: WhoLmsData(l: -0.8693, m: 17.5593, s: 0.09128),
    46: WhoLmsData(l: -0.8700, m: 17.6818, s: 0.09218),
    47: WhoLmsData(l: -0.8709, m: 17.8051, s: 0.09306),
    48: WhoLmsData(l: -0.8720, m: 17.9290, s: 0.09394),
    49: WhoLmsData(l: -0.8731, m: 18.0534, s: 0.09479),
    50: WhoLmsData(l: -0.8744, m: 18.1783, s: 0.09564),
    51: WhoLmsData(l: -0.8757, m: 18.3036, s: 0.09647),
    52: WhoLmsData(l: -0.8771, m: 18.4293, s: 0.09729),
    53: WhoLmsData(l: -0.8786, m: 18.5552, s: 0.09809),
    54: WhoLmsData(l: -0.8801, m: 18.6814, s: 0.09888),
    55: WhoLmsData(l: -0.8817, m: 18.8078, s: 0.09966),
    56: WhoLmsData(l: -0.8833, m: 18.9344, s: 0.10043),
    57: WhoLmsData(l: -0.8849, m: 19.0611, s: 0.10118),
    58: WhoLmsData(l: -0.8865, m: 19.1879, s: 0.10193),
    59: WhoLmsData(l: -0.8882, m: 19.3148, s: 0.10266),
    60: WhoLmsData(l: -0.8898, m: 19.4417, s: 0.10339),
  };

  // ============================================================================
  // BMI-FOR-AGE (IMT/U) - GIRLS (Perempuan)
  // Unit: kg/m²
  // ============================================================================
  static const Map<int, WhoLmsData> bmiForAgeGirls = {
    0: WhoLmsData(l: -1.6961, m: 13.2122, s: 0.09182),
    1: WhoLmsData(l: -1.7069, m: 15.6817, s: 0.08244),
    2: WhoLmsData(l: -1.6992, m: 16.8295, s: 0.07684),
    3: WhoLmsData(l: -1.6773, m: 17.2462, s: 0.07379),
    4: WhoLmsData(l: -1.6449, m: 17.3565, s: 0.07189),
    5: WhoLmsData(l: -1.6051, m: 17.3002, s: 0.07062),
    6: WhoLmsData(l: -1.5606, m: 17.1549, s: 0.06970),
    7: WhoLmsData(l: -1.5137, m: 16.9626, s: 0.06900),
    8: WhoLmsData(l: -1.4662, m: 16.7470, s: 0.06845),
    9: WhoLmsData(l: -1.4192, m: 16.5235, s: 0.06801),
    10: WhoLmsData(l: -1.3738, m: 16.3010, s: 0.06766),
    11: WhoLmsData(l: -1.3304, m: 16.0862, s: 0.06738),
    12: WhoLmsData(l: -1.2895, m: 15.8842, s: 0.06718),
    13: WhoLmsData(l: -1.2513, m: 15.6989, s: 0.06705),
    14: WhoLmsData(l: -1.2158, m: 15.5330, s: 0.06700),
    15: WhoLmsData(l: -1.1831, m: 15.3884, s: 0.06704),
    16: WhoLmsData(l: -1.1532, m: 15.2664, s: 0.06716),
    17: WhoLmsData(l: -1.1259, m: 15.1673, s: 0.06736),
    18: WhoLmsData(l: -1.1011, m: 15.0910, s: 0.06766),
    19: WhoLmsData(l: -1.0787, m: 15.0367, s: 0.06804),
    20: WhoLmsData(l: -1.0584, m: 15.0035, s: 0.06851),
    21: WhoLmsData(l: -1.0401, m: 14.9899, s: 0.06906),
    22: WhoLmsData(l: -1.0236, m: 14.9945, s: 0.06968),
    23: WhoLmsData(l: -1.0087, m: 15.0157, s: 0.07037),
    24: WhoLmsData(l: -0.9953, m: 15.0521, s: 0.07113),
    25: WhoLmsData(l: -0.9833, m: 15.1024, s: 0.07194),
    26: WhoLmsData(l: -0.9726, m: 15.1653, s: 0.07281),
    27: WhoLmsData(l: -0.9630, m: 15.2396, s: 0.07373),
    28: WhoLmsData(l: -0.9544, m: 15.3245, s: 0.07469),
    29: WhoLmsData(l: -0.9468, m: 15.4189, s: 0.07569),
    30: WhoLmsData(l: -0.9401, m: 15.5220, s: 0.07673),
    31: WhoLmsData(l: -0.9342, m: 15.6330, s: 0.07780),
    32: WhoLmsData(l: -0.9290, m: 15.7510, s: 0.07890),
    33: WhoLmsData(l: -0.9245, m: 15.8755, s: 0.08002),
    34: WhoLmsData(l: -0.9206, m: 16.0059, s: 0.08116),
    35: WhoLmsData(l: -0.9173, m: 16.1417, s: 0.08232),
    36: WhoLmsData(l: -0.9145, m: 16.2823, s: 0.08349),
    37: WhoLmsData(l: -0.9121, m: 16.4274, s: 0.08467),
    38: WhoLmsData(l: -0.9102, m: 16.5765, s: 0.08585),
    39: WhoLmsData(l: -0.9086, m: 16.7293, s: 0.08704),
    40: WhoLmsData(l: -0.9074, m: 16.8854, s: 0.08823),
    41: WhoLmsData(l: -0.9065, m: 17.0445, s: 0.08942),
    42: WhoLmsData(l: -0.9059, m: 17.2063, s: 0.09060),
    43: WhoLmsData(l: -0.9055, m: 17.3706, s: 0.09178),
    44: WhoLmsData(l: -0.9054, m: 17.5371, s: 0.09295),
    45: WhoLmsData(l: -0.9055, m: 17.7056, s: 0.09412),
    46: WhoLmsData(l: -0.9058, m: 17.8760, s: 0.09528),
    47: WhoLmsData(l: -0.9062, m: 18.0480, s: 0.09643),
    48: WhoLmsData(l: -0.9067, m: 18.2216, s: 0.09757),
    49: WhoLmsData(l: -0.9074, m: 18.3965, s: 0.09870),
    50: WhoLmsData(l: -0.9082, m: 18.5727, s: 0.09982),
    51: WhoLmsData(l: -0.9091, m: 18.7501, s: 0.10093),
    52: WhoLmsData(l: -0.9100, m: 18.9286, s: 0.10203),
    53: WhoLmsData(l: -0.9110, m: 19.1080, s: 0.10312),
    54: WhoLmsData(l: -0.9121, m: 19.2884, s: 0.10420),
    55: WhoLmsData(l: -0.9132, m: 19.4696, s: 0.10527),
    56: WhoLmsData(l: -0.9143, m: 19.6516, s: 0.10633),
    57: WhoLmsData(l: -0.9155, m: 19.8343, s: 0.10738),
    58: WhoLmsData(l: -0.9166, m: 20.0177, s: 0.10842),
    59: WhoLmsData(l: -0.9178, m: 20.2017, s: 0.10945),
    60: WhoLmsData(l: -0.9190, m: 20.3863, s: 0.11047),
  };

  /// Get BMI-for-age reference data
  static WhoLmsData? getBmiForAge(int ageMonths, String gender) {
    if (ageMonths < 0 || ageMonths > 60) return null;
    
    if (gender == 'L') {
      return bmiForAgeBoys[ageMonths];
    } else {
      return bmiForAgeGirls[ageMonths];
    }
  }
}
