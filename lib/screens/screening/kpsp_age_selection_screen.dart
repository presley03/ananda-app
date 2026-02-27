import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/kpsp_data_loader.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import 'kpsp_questions_screen.dart';

class KpspAgeSelectionScreen extends StatefulWidget {
  final ChildProfile? child;
  const KpspAgeSelectionScreen({super.key, this.child});

  @override
  State<KpspAgeSelectionScreen> createState() => _KpspAgeSelectionScreenState();
}

class _KpspAgeSelectionScreenState extends State<KpspAgeSelectionScreen> {
  static const List<int> _ages = [
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    30,
    36,
    42,
    48,
    54,
    60,
    66,
    72,
  ];

  final DatabaseService _db = DatabaseService();
  List<ChildProfile> _children = [];
  ChildProfile? _selectedChild;
  int? _selectedAge;
  bool _isLoading = false;
  bool _loadingChildren = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
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
        if (_selectedChild != null) {
          _selectedAge = _nearestAge(_selectedChild!.ageInMonths);
        }
        _loadingChildren = false;
      });
    } catch (e) {
      setState(() => _loadingChildren = false);
    }
  }

  int _nearestAge(int ageInMonths) {
    for (int i = _ages.length - 1; i >= 0; i--) {
      if (ageInMonths >= _ages[i]) return _ages[i];
    }
    return _ages.first;
  }

  static const List<List<int>> _childPalettes = [
    [0xFFFFF0ED, 0xFFFF6B6B],
    [0xFFEDF6FF, 0xFF5B9BD5],
    [0xFFFFFBED, 0xFFD4AC0D],
    [0xFFEDFFF5, 0xFF4CAF82],
    [0xFFF3EDFF, 0xFF9B72CF],
    [0xFFFFEDF5, 0xFFE0679A],
  ];

  Color _childBg(int index) =>
      Color(_childPalettes[index % _childPalettes.length][0]);
  Color _childAccent(int index) =>
      Color(_childPalettes[index % _childPalettes.length][1]);

  Color get _activeAccent {
    if (_selectedChild == null) return const Color(0xFFFF6B6B);
    final idx = _children.indexOf(_selectedChild!);
    return _childAccent(idx < 0 ? 0 : idx);
  }

  Color get _activeBg {
    if (_selectedChild == null) return const Color(0xFFFFF0ED);
    final idx = _children.indexOf(_selectedChild!);
    return _childBg(idx < 0 ? 0 : idx);
  }

  String _ageLabel(int months) {
    if (months < 12) return '$months Bulan';
    final y = months ~/ 12;
    final m = months % 12;
    if (m == 0) return '$y Tahun';
    return '$y Thn $m Bln';
  }

  Future<void> _startScreening() async {
    if (_selectedAge == null) return;
    setState(() => _isLoading = true);
    try {
      final questions = await KpspDataLoader.loadQuestions(_selectedAge!);
      if (questions == null || questions.isEmpty) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data pertanyaan tidak ditemukan')),
          );
        }
        return;
      }
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => KpspQuestionsScreen(
                  ageMonths: _selectedAge!,
                  questions: questions,
                  child: _selectedChild,
                ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child:
                _loadingChildren
                    ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_children.isNotEmpty) ...[
                            _buildSectionLabel('PROFIL ANAK'),
                            const SizedBox(height: 8),
                            _buildChildSelector(),
                            const SizedBox(height: 24),
                          ],
                          _buildSectionLabel('KATEGORI USIA KPSP'),
                          const SizedBox(height: 4),
                          Text(
                            _selectedChild != null
                                ? 'Terdeteksi: ${_selectedChild!.ageDescription}. Pilih kategori yang sesuai.'
                                : 'Pilih kategori usia yang mendekati usia anak saat ini.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAgeGrid(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
          ),

          // TOMBOL MULAI - fixed bottom
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24 + MediaQuery.of(context).padding.bottom,
            ),
            child: GestureDetector(
              onTap:
                  (_selectedAge == null || _isLoading) ? null : _startScreening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient:
                      _selectedAge != null
                          ? LinearGradient(
                            colors: [
                              _activeAccent,
                              _activeAccent.withValues(alpha: 0.75),
                            ],
                          )
                          : null,
                  color: _selectedAge == null ? const Color(0xFFE0E0E0) : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            _selectedAge == null
                                ? 'Pilih usia terlebih dahulu'
                                : 'Mulai Skrining KPSP',
                            style: TextStyle(
                              color:
                                  _selectedAge == null
                                      ? AppColors.textHint
                                      : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 20, 32),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KPSP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Kuesioner Pra Skrining Perkembangan',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              final isSelected = _selectedChild?.id == child.id;
              final isBoy = child.gender == 'L';
              final accent = _childAccent(index);
              final bg = _childBg(index);
              return GestureDetector(
                onTap:
                    () => setState(() {
                      _selectedChild = child;
                      _selectedAge = _nearestAge(child.ageInMonths);
                    }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? bg : const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? accent : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isBoy ? Icons.boy_rounded : Icons.girl_rounded,
                        color: isSelected ? accent : AppColors.textHint,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            child.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color:
                                  isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            child.ageDescription,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected ? accent : AppColors.textHint,
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
    );
  }

  Widget _buildAgeGrid() {
    final accent = _activeAccent;
    final bg = _activeBg;
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      padding: EdgeInsets.zero,
      children:
          _ages.map((age) {
            final isSelected = _selectedAge == age;
            final isRecommended =
                _selectedChild != null &&
                _nearestAge(_selectedChild!.ageInMonths) == age;
            return GestureDetector(
              onTap: () => setState(() => _selectedAge = age),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? accent
                          : isRecommended
                          ? bg
                          : const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected
                            ? accent
                            : isRecommended
                            ? accent.withValues(alpha: 0.4)
                            : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isRecommended && !isSelected)
                      Text('*', style: TextStyle(fontSize: 10, color: accent)),
                    Text(
                      _ageLabel(age),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected
                                ? Colors.white
                                : isRecommended
                                ? accent
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}
