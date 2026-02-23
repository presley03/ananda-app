import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import '../../models/screening_result.dart';
import '../../screens/screening/screening_result_detail_screen.dart';
import 'edit_profile_screen.dart';

class ProfileDetailScreen extends StatefulWidget {
  final ChildProfile profile;
  const ProfileDetailScreen({super.key, required this.profile});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<ScreeningResult> _screeningHistory = [];
  bool _isLoading = true;
  late ChildProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _loadScreeningHistory();
  }

  Future<void> _loadScreeningHistory() async {
    setState(() => _isLoading = true);
    try {
      final results = await _dbService.getScreeningResultsByChild(_profile.id!);
      setState(() {
        _screeningHistory =
            results.map((m) => ScreeningResult.fromMap(m)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: _profile),
      ),
    );
    if (result == true && mounted) Navigator.pop(context, true);
  }

  Future<void> _deleteProfile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Hapus Profil?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              'Profil ${_profile.name} dan semua riwayat skrining akan dihapus permanen.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await _dbService.deleteChild(_profile.id!);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBoy = _profile.gender == 'L';
    final color = isBoy ? AppColors.accentTeal : const Color(0xFFE0679A);
    final bg = isBoy ? const Color(0xFFEDFAFF) : const Color(0xFFFFEDF5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(color, isBoy)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Info dasar
                _buildInfoCard(color, bg),
                const SizedBox(height: 16),

                // Shortcut skrining
                const SizedBox(height: 8),
                _buildSectionLabel('MULAI SKRINING'),
                const SizedBox(height: 8),
                _buildScreeningShortcuts(color),
                const SizedBox(height: 24),

                // Riwayat skrining
                _buildSectionLabel('RIWAYAT SKRINING'),
                const SizedBox(height: 8),
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    )
                    : _screeningHistory.isEmpty
                    ? _buildEmptyHistory()
                    : _buildHistoryList(),

                const SizedBox(height: 32),

                // Disclaimer privasi
                _buildPrivacyNote(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color, bool isBoy) {
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    onPressed: _editProfile,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _deleteProfile,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Foto / Avatar
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(22),
                ),
                child:
                    _profile.photoPath != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.file(
                            File(_profile.photoPath!),
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(
                          isBoy ? Icons.boy_rounded : Icons.girl_rounded,
                          color: Colors.white,
                          size: 46,
                        ),
              ),
              const SizedBox(height: 12),

              Text(
                _profile.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _profile.ageDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _profile.genderDisplay,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.cake_rounded,
            'Tanggal Lahir',
            '${_profile.birthDate.day}/${_profile.birthDate.month}/${_profile.birthDate.year}',
            color,
          ),
          if (_profile.birthPlace != null &&
              _profile.birthPlace!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.location_on_rounded,
              'Tempat Lahir',
              _profile.birthPlace!,
              color,
            ),
          ],
          if (_profile.identityNumber != null &&
              _profile.identityNumber!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.badge_rounded,
              'No. Identitas Anak',
              _profile.identityNumber!,
              color,
            ),
          ],
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.child_care_rounded,
            'Kategori Materi',
            '${_profile.materialCategory} Tahun',
            color,
          ),
          const SizedBox(height: 12),
          // Progress bar usia
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _profile.ageInMonths.clamp(0, 60) / 60,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_profile.ageInMonths} dari 60 bulan (5 tahun)',
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildScreeningShortcuts(Color color) {
    final shortcuts = [
      {
        'label': 'KPSP',
        'sub': 'Perkembangan',
        'icon': Icons.fact_check_rounded,
        'bg': const Color(0xFFFFF0ED),
        'accent': AppColors.primary,
      },
      {
        'label': 'Kalkulator Gizi',
        'sub': 'Nutrisi',
        'icon': Icons.restaurant_rounded,
        'bg': const Color(0xFFEDFFF5),
        'accent': AppColors.success,
      },
      {
        'label': 'TDD',
        'sub': 'Daya Dengar',
        'icon': Icons.hearing_rounded,
        'bg': const Color(0xFFEDF6FF),
        'accent': AppColors.accentTeal,
      },
      {
        'label': 'M-CHAT-R',
        'sub': 'Autisme',
        'icon': Icons.psychology_rounded,
        'bg': const Color(0xFFF3EDFF),
        'accent': AppColors.accentPurple,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: EdgeInsets.zero,
      childAspectRatio: 2.4,
      children:
          shortcuts.map((s) {
            final accent = s['accent'] as Color;
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mulai ${s['label']} untuk ${_profile.name}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: s['bg'] as Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(s['icon'] as IconData, color: accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s['label'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            s['sub'] as String,
                            style: TextStyle(fontSize: 10, color: accent),
                          ),
                        ],
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

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Belum ada riwayat skrining',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children:
          _screeningHistory.map((result) {
            IconData icon;
            Color itemColor;
            String typeLabel;
            switch (result.screeningType) {
              case 'kpsp':
                icon = Icons.fact_check_rounded;
                itemColor = AppColors.accentTeal;
                typeLabel = 'KPSP';
                break;
              case 'nutrition':
                icon = Icons.restaurant_rounded;
                itemColor = AppColors.success;
                typeLabel = 'Kalkulator Gizi';
                break;
              case 'tdd':
                icon = Icons.hearing_rounded;
                itemColor = const Color(0xFF5B9BD5);
                typeLabel = 'TDD';
                break;
              case 'mchat':
                icon = Icons.psychology_rounded;
                itemColor = AppColors.accentPurple;
                typeLabel = 'M-CHAT-R';
                break;
              default:
                icon = Icons.check_circle_rounded;
                itemColor = AppColors.primary;
                typeLabel = 'Skrining';
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ScreeningResultDetailScreen(result: result),
                      ),
                    ).then((deleted) {
                      if (deleted == true) _loadScreeningHistory();
                    }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: itemColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: itemColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: itemColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              typeLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              result.result,
                              style: TextStyle(
                                fontSize: 12,
                                color: itemColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        result.formattedDate,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: itemColor.withValues(alpha: 0.5),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Tersimpan Lokal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Semua data profil dan riwayat skrining hanya tersimpan di perangkat ini. '
                  'Kami tidak mengumpulkan, mengunggah, atau membagikan data Anda ke server manapun. '
                  'Aplikasi ini sepenuhnya bekerja secara offline.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
