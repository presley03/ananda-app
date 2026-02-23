import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/tdd_data_loader.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import 'tdd_questions_screen.dart';

class TddAgeSelectionScreen extends StatefulWidget {
  final ChildProfile? child;
  const TddAgeSelectionScreen({super.key, this.child});

  @override
  State<TddAgeSelectionScreen> createState() => _TddAgeSelectionScreenState();
}

class _TddAgeSelectionScreenState extends State<TddAgeSelectionScreen> {
  static const List<String> _ranges = [
    '<3',
    '3-6',
    '6-12',
    '12-24',
    '24-36',
    '>36',
  ];

  static const Map<String, String> _shortLabel = {
    '<3': '< 3 Bln',
    '3-6': '3-6 Bln',
    '6-12': '6-12 Bln',
    '12-24': '1-2 Thn',
    '24-36': '2-3 Thn',
    '>36': '> 3 Thn',
  };

  static const Map<String, String> _longLabel = {
    '<3': 'Kurang dari 3 bulan',
    '3-6': '3 sampai 6 bulan',
    '6-12': '6 sampai 12 bulan',
    '12-24': '1 sampai 2 tahun',
    '24-36': '2 sampai 3 tahun',
    '>36': 'Lebih dari 3 tahun',
  };

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

  Color get _activeAccent {
    if (_selectedChild == null) return const Color(0xFF5B9BD5);
    final i = _children.indexOf(_selectedChild!);
    return _childAccent(i < 0 ? 0 : i);
  }

  Color get _activeBg {
    if (_selectedChild == null) return const Color(0xFFEDF6FF);
    final i = _children.indexOf(_selectedChild!);
    return _childBg(i < 0 ? 0 : i);
  }

  List<ChildProfile> _children = [];
  ChildProfile? _selectedChild;
  String? _selectedRange;
  bool _isLoading = false;
  bool _loadingChildren = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final maps = await DatabaseService().getAllChildren();
      final children = maps.map((m) => ChildProfile.fromMap(m)).toList();
      setState(() {
        _children = children;
        _selectedChild =
            widget.child ?? (children.isNotEmpty ? children.first : null);
        if (_selectedChild != null) {
          _selectedRange = _nearestRange(_selectedChild!.ageInMonths);
        }
        _loadingChildren = false;
      });
    } catch (_) {
      setState(() => _loadingChildren = false);
    }
  }

  String _nearestRange(int months) {
    if (months < 3) return '<3';
    if (months < 6) return '3-6';
    if (months < 12) return '6-12';
    if (months < 24) return '12-24';
    if (months < 36) return '24-36';
    return '>36';
  }

  Future<void> _start() async {
    if (_selectedRange == null) return;
    setState(() => _isLoading = true);
    final questions = await TddDataLoader.loadQuestions(_selectedRange!);
    if (questions == null || questions.isEmpty) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pertanyaan tidak ditemukan')),
        );
      }
      return;
    }
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => TddQuestionsScreen(
                ageRange: _selectedRange!,
                child: _selectedChild,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _activeAccent;
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
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.accentTeal,
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_children.isNotEmpty) ...[
                            _sectionLabel('PROFIL ANAK'),
                            const SizedBox(height: 8),
                            _buildChildSelector(),
                            const SizedBox(height: 24),
                          ],
                          _sectionLabel('KATEGORI USIA TDD'),
                          const SizedBox(height: 4),
                          Text(
                            _selectedChild != null
                                ? 'Terdeteksi: ${_selectedChild!.ageDescription}. Pilih kategori yang sesuai.'
                                : 'Pilih rentang usia anak saat ini.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildRangeGrid(accent),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
          ),

          // TOMBOL MULAI - fixed bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: GestureDetector(
              onTap: (_selectedRange == null || _isLoading) ? null : _start,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient:
                      _selectedRange != null
                          ? LinearGradient(
                            colors: [accent, accent.withValues(alpha: 0.75)],
                          )
                          : null,
                  color:
                      _selectedRange == null ? const Color(0xFFE0E0E0) : null,
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
                            _selectedRange == null
                                ? 'Pilih usia terlebih dahulu'
                                : 'Mulai Skrining TDD',
                            style: TextStyle(
                              color:
                                  _selectedRange == null
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
          colors: [AppColors.accentTeal, Color(0xFF26A69A)],
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TDD',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Tes Daya Dengar',
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
            _children.asMap().entries.map((e) {
              final i = e.key;
              final child = e.value;
              final isSelected = _selectedChild?.id == child.id;
              final accent = _childAccent(i);
              final bg = _childBg(i);
              return GestureDetector(
                onTap:
                    () => setState(() {
                      _selectedChild = child;
                      _selectedRange = _nearestRange(child.ageInMonths);
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
                        child.gender == 'L'
                            ? Icons.boy_rounded
                            : Icons.girl_rounded,
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

  Widget _buildRangeGrid(Color accent) {
    final recommended =
        _selectedChild != null
            ? _nearestRange(_selectedChild!.ageInMonths)
            : null;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      padding: EdgeInsets.zero,
      children:
          _ranges.map((r) {
            final isSelected = _selectedRange == r;
            final isRecommended = recommended == r;
            return GestureDetector(
              onTap: () => setState(() => _selectedRange = r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? accent
                          : isRecommended
                          ? _activeBg
                          : const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(14),
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
                      _shortLabel[r] ?? r,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected
                                ? Colors.white
                                : isRecommended
                                ? accent
                                : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _longLabel[r] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected ? Colors.white70 : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _sectionLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    ),
  );
}
