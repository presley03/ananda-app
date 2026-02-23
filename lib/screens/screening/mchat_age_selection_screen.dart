import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import 'mchat_questions_screen.dart';

class MchatAgeSelectionScreen extends StatefulWidget {
  final ChildProfile? child;
  const MchatAgeSelectionScreen({super.key, this.child});

  @override
  State<MchatAgeSelectionScreen> createState() =>
      _MchatAgeSelectionScreenState();
}

class _MchatAgeSelectionScreenState extends State<MchatAgeSelectionScreen> {
  final DatabaseService _db = DatabaseService();
  List<ChildProfile> _children = [];
  ChildProfile? _selectedChild;
  bool _loadingChildren = true;

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
    if (_selectedChild == null) return AppColors.primary;
    final idx = _children.indexOf(_selectedChild!);
    return _childAccent(idx < 0 ? 0 : idx);
  }

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
        _loadingChildren = false;
      });
    } catch (e) {
      setState(() => _loadingChildren = false);
    }
  }

  void _startScreening() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MchatQuestionsScreen(child: _selectedChild),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'M-CHAT-R',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Skrining Autisme (16-30 Bulan)',
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
                          // Info usia
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'M-CHAT-R digunakan untuk anak usia 16 hingga 30 bulan sebagai skrining dini gangguan spektrum autisme.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Pilih anak
                          if (_children.isNotEmpty) ...[
                            const Text(
                              'PROFIL ANAK',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _children.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final c = entry.value;
                                      final isSelected =
                                          _selectedChild?.id == c.id;
                                      final accent = _childAccent(index);
                                      final bg = _childBg(index);
                                      return GestureDetector(
                                        onTap:
                                            () => setState(
                                              () => _selectedChild = c,
                                            ),
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
                                                    : const Color(0xFFF8F8F8),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
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
                            const SizedBox(height: 24),
                          ],

                          // Peringatan jika tidak ada profil
                          if (_children.isEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.warning.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: AppColors.warning,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Belum ada profil anak. Hasil tidak akan tersimpan ke riwayat.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Info skrining
                          const Text(
                            'INFORMASI SKRINING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _infoItem(
                            Icons.quiz_rounded,
                            '20 pertanyaan Ya/Tidak',
                          ),
                          const SizedBox(height: 8),
                          _infoItem(
                            Icons.star_rounded,
                            '7 item kritis untuk deteksi awal',
                          ),
                          const SizedBox(height: 8),
                          _infoItem(
                            Icons.timer_outlined,
                            'Estimasi waktu: 5-10 menit',
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
          ),

          // TOMBOL MULAI - fixed di bawah
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _startScreening,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _activeAccent,
                        _activeAccent.withValues(alpha: 0.75),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Mulai Skrining M-CHAT-R',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
