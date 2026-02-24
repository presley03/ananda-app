import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/nutrition_measurement.dart';
import '../../models/child_profile.dart';
import '../../services/database_service.dart';
import '../../services/nutrition_calculator.dart';
import '../../utils/constants/colors.dart';
import 'nutrition_result_screen.dart';

class NutritionInputScreen extends StatefulWidget {
  final ChildProfile? child;
  const NutritionInputScreen({super.key, this.child});

  @override
  State<NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<NutritionInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageYearsController = TextEditingController();
  final _ageMonthsController = TextEditingController();

  final DatabaseService _db = DatabaseService();
  List<ChildProfile> _children = [];
  ChildProfile? _selectedChild;
  bool _loadingChildren = true;
  String _selectedGender = 'L';

  static const List<List<int>> _childPalettes = [
    [0xFFFFF0ED, 0xFFFF6B6B],
    [0xFFEDF6FF, 0xFF5B9BD5],
    [0xFFFFFBED, 0xFFD4AC0D],
    [0xFFEDFFF5, 0xFF4CAF82],
    [0xFFF3EDFF, 0xFF9B72CF],
    [0xFFFFEDF5, 0xFFE0679A],
  ];

  Color _childBg(int i) => Color(_childPalettes[i % _childPalettes.length][0]);
  Color _childAccent(int i) =>
      Color(_childPalettes[i % _childPalettes.length][1]);

  static const Color _green = Color(0xFF27AE60);
  static const Color _greenLight = Color(0xFF2ECC71);

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageYearsController.dispose();
    _ageMonthsController.dispose();
    super.dispose();
  }

  Future<void> _loadChildren() async {
    try {
      final maps = await _db.getAllChildren();
      final children = maps.map((m) => ChildProfile.fromMap(m)).toList();
      setState(() {
        _children = children;
        if (widget.child != null) {
          _selectedChild = widget.child;
        } else if (children.isNotEmpty) {
          _selectedChild = children.first;
        }
        if (_selectedChild != null) _fillFromChild(_selectedChild!);
        _loadingChildren = false;
      });
    } catch (e) {
      setState(() => _loadingChildren = false);
    }
  }

  void _fillFromChild(ChildProfile child) {
    final totalMonths = child.ageInMonths;
    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;
    _ageYearsController.text = years > 0 ? '$years' : '';
    _ageMonthsController.text = months > 0 ? '$months' : '';
    setState(() => _selectedGender = child.gender);
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final ageYears = int.tryParse(_ageYearsController.text) ?? 0;
    final ageMonths = int.tryParse(_ageMonthsController.text) ?? 0;
    final totalAgeMonths = (ageYears * 12) + ageMonths;

    if (totalAgeMonths > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Umur maksimal 5 tahun (60 bulan)'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    if (totalAgeMonths == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Umur harus diisi'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final measurement = NutritionMeasurement(
      weight: weight,
      height: height,
      ageMonths: totalAgeMonths,
      gender: _selectedGender,
      measurementDate: DateTime.now(),
    );

    final result = NutritionCalculator.calculate(measurement);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NutritionResultScreen(
              measurement: measurement,
              result: result,
              child: _selectedChild,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // HEADER
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_green, _greenLight],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 20, 28),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kalkulator Gizi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Status Gizi Anak (0-5 Tahun)',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child:
                _loadingChildren
                    ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_green),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pilih profil anak
                            if (_children.isNotEmpty) ...[
                              _label('PROFIL ANAK'),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      _children.asMap().entries.map((entry) {
                                        final i = entry.key;
                                        final c = entry.value;
                                        final isSelected =
                                            _selectedChild?.id == c.id;
                                        final accent = _childAccent(i);
                                        final bg = _childBg(i);
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() => _selectedChild = c);
                                            _fillFromChild(c);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? bg
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? accent
                                                        : Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  c.gender == 'L'
                                                      ? Icons.boy_rounded
                                                      : Icons.girl_rounded,
                                                  color:
                                                      isSelected
                                                          ? accent
                                                          : AppColors.textHint,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      c.name,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            isSelected
                                                                ? AppColors
                                                                    .textPrimary
                                                                : AppColors
                                                                    .textSecondary,
                                                      ),
                                                    ),
                                                    Text(
                                                      c.ageDescription,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            isSelected
                                                                ? accent
                                                                : AppColors
                                                                    .textHint,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Berat badan
                            _label('BERAT BADAN'),
                            const SizedBox(height: 8),
                            _field(
                              controller: _weightController,
                              hint: 'Contoh: 10.5',
                              suffix: 'kg',
                              icon: Icons.monitor_weight_outlined,
                              keyboard: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              formatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Berat badan harus diisi';
                                }
                                final w = double.tryParse(v);
                                if (w == null || w <= 0 || w > 50) {
                                  return 'Berat tidak valid (1-50 kg)';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Tinggi badan
                            _label('PANJANG / TINGGI BADAN'),
                            const SizedBox(height: 4),
                            const Text(
                              'Di bawah 2 tahun diukur berbaring, 2 tahun ke atas diukur berdiri',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _field(
                              controller: _heightController,
                              hint: 'Contoh: 85.5',
                              suffix: 'cm',
                              icon: Icons.height_rounded,
                              keyboard: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              formatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Tinggi badan harus diisi';
                                }
                                final h = double.tryParse(v);
                                if (h == null || h < 40 || h > 130) {
                                  return 'Tinggi tidak valid (40-130 cm)';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Umur
                            _label('UMUR ANAK'),
                            const SizedBox(height: 4),
                            const Text(
                              'Maksimal 5 tahun (60 bulan)',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    controller: _ageYearsController,
                                    hint: '0',
                                    suffix: 'tahun',
                                    icon: Icons.cake_outlined,
                                    keyboard: TextInputType.number,
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _field(
                                    controller: _ageMonthsController,
                                    hint: '0',
                                    suffix: 'bulan',
                                    icon: Icons.today_outlined,
                                    keyboard: TextInputType.number,
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Jenis kelamin
                            _label('JENIS KELAMIN'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _genderCard(
                                    'L',
                                    'Laki-laki',
                                    Icons.boy_rounded,
                                    AppColors.accentTeal,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _genderCard(
                                    'P',
                                    'Perempuan',
                                    Icons.girl_rounded,
                                    const Color(0xFFE0679A),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
          ),

          // TOMBOL HITUNG - fixed di bawah
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: GestureDetector(
              onTap: _calculate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_green, _greenLight]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calculate_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Hitung Status Gizi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required String suffix,
    required IconData icon,
    required TextInputType keyboard,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: formatters,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        suffixText: suffix,
        suffixStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF27AE60), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF27AE60), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }

  Widget _genderCard(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textHint,
              size: 36,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
