import 'package:flutter/material.dart';
import 'dart:async';
import '../models/material.dart' as model;
import '../services/database_service.dart';
import '../utils/constants/colors.dart';
import 'material_detail_screen.dart';

class MaterialSearchScreen extends StatefulWidget {
  const MaterialSearchScreen({super.key});

  @override
  State<MaterialSearchScreen> createState() => _MaterialSearchScreenState();
}

class _MaterialSearchScreenState extends State<MaterialSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final DatabaseService _db = DatabaseService();

  List<model.Material> _searchResults = [];
  List<model.Material> _allMaterials = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _selectedCategory;
  Timer? _debounce;

  // Palette warna selang-seling — sama dengan material_list_item
  static const List<List<Color>> _palette = [
    [Color(0xFFFFF0ED), Color(0xFFFF6B6B)],
    [Color(0xFFEDF6FF), Color(0xFF5B9BD5)],
    [Color(0xFFFFFBED), Color(0xFFD4AC0D)],
    [Color(0xFFEDFFF5), Color(0xFF4CAF82)],
    [Color(0xFFFFF3ED), Color(0xFFFF8C42)],
    [Color(0xFFF3EDFF), Color(0xFF9B72CF)],
  ];

  @override
  void initState() {
    super.initState();
    _loadAllMaterials();
    _searchController.addListener(_onSearchChanged);
    // Auto focus keyboard saat masuk screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAllMaterials() async {
    final db = await _db.database;
    final maps = await db.query('materials');
    setState(() {
      _allMaterials = maps.map((m) => model.Material.fromMap(m)).toList();
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _performSearch);
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty && _selectedCategory == null) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    List<model.Material> results = _allMaterials;
    if (query.isNotEmpty) {
      results = results.where((m) => m.matchesKeyword(query)).toList();
    }
    if (_selectedCategory != null) {
      results = results.where((m) => m.category == _selectedCategory).toList();
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _selectedCategory = null;
      _searchController.clear();
      _searchResults = [];
      _hasSearched = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryChips(),
          if (_hasSearched && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Ditemukan ${_searchResults.length} materi',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _buildBody()),
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Cari Materi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (_hasSearched)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari materi, topik, kata kunci...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.textHint.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.textHint,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch();
                                },
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['0-1 Tahun', '1-2 Tahun', '2-5 Tahun'];
    final values = ['0-1', '1-2', '2-5'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final isSelected = _selectedCategory == values[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = isSelected ? null : values[index];
                });
                _performSearch();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primary
                            : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (!_hasSearched) {
      return _buildEmptyState(
        icon: Icons.search_rounded,
        title: 'Cari Materi',
        subtitle: 'Ketik kata kunci untuk mulai pencarian',
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off_rounded,
        title: 'Tidak Ditemukan',
        subtitle: 'Coba gunakan kata kunci yang berbeda',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _buildResultCard(_searchResults[index], index);
      },
    );
  }

  Widget _buildResultCard(model.Material material, int index) {
    final colors = _palette[index % _palette.length];
    final bg = colors[0];
    final accent = colors[1];

    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaterialDetailScreen(material: material),
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildBadge(material.categoryDisplay, accent),
                const SizedBox(width: 8),
                Text(
                  material.subcategoryDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: accent.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 3),
                Text(
                  '${material.estimatedReadingTime} mnt',
                  style: TextStyle(
                    fontSize: 11,
                    color: accent.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              material.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              material.contentPreview,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
