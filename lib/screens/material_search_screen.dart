import 'package:flutter/material.dart';
import 'dart:async';
import '../models/material.dart' as model;
import '../services/database_service.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../widgets/simple_card.dart';
import 'material_detail_screen.dart';

/// Material Search Screen
/// Screen untuk mencari materi edukatif dengan fitur:
/// - Real-time search
/// - Filter by kategori & usia
/// - Highlight keyword
/// - Empty state & loading state
class MaterialSearchScreen extends StatefulWidget {
  const MaterialSearchScreen({super.key});

  @override
  State<MaterialSearchScreen> createState() => _MaterialSearchScreenState();
}

class _MaterialSearchScreenState extends State<MaterialSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _db = DatabaseService();

  List<model.Material> _searchResults = [];
  List<model.Material> _allMaterials = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  // Filter state
  String? _selectedCategory;
  String? _selectedSubcategory;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadAllMaterials();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Load all materials for filtering
  Future<void> _loadAllMaterials() async {
    final db = await _db.database;
    final maps = await db.query('materials');
    setState(() {
      _allMaterials = maps.map((m) => model.Material.fromMap(m)).toList();
    });
  }

  /// Handle search text changes with debounce
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch();
    });
  }

  /// Perform search
  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    if (query.isEmpty &&
        _selectedCategory == null &&
        _selectedSubcategory == null) {
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

    // Filter materials
    List<model.Material> results = _allMaterials;

    // Filter by keyword
    if (query.isNotEmpty) {
      results =
          results.where((material) {
            return material.matchesKeyword(query);
          }).toList();
    }

    // Filter by category
    if (_selectedCategory != null) {
      results = results.where((m) => m.category == _selectedCategory).toList();
    }

    // Filter by subcategory
    if (_selectedSubcategory != null) {
      results =
          results.where((m) => m.subcategory == _selectedSubcategory).toList();
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  /// Clear all filters
  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedSubcategory = null;
      _searchController.clear();
      _searchResults = [];
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              _buildHeader(),

              // Search bar
              _buildSearchBar(),

              // Filters + Results (wrapped in Expanded untuk scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildFilters(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 280,
                        child: _buildResults(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.spacingM),

          // Title
          const Expanded(
            child: Text(
              'Cari Materi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Clear filters button
          if (_hasSearched)
            GestureDetector(
              onTap: _clearFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.clear_rounded,
                      color: AppColors.danger,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Reset',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari materi, nutrisi, perkembangan...',
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingM,
            ),
          ),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  /// Build filters (category & subcategory chips) - COMPACT VERSION
  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filter
          const Text(
            'Usia:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua', null, true),
                _buildFilterChip('0-1 Tahun', '0-1', true),
                _buildFilterChip('1-2 Tahun', '1-2', true),
                _buildFilterChip('2-5 Tahun', '2-5', true),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingS),

          // Subcategory filter
          const Text(
            'Kategori:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua', null, false),
                _buildFilterChip('Nutrisi', 'Nutrisi', false),
                _buildFilterChip('Pertumbuhan', 'Pertumbuhan', false),
                _buildFilterChip('Perkembangan', 'Perkembangan', false),
                _buildFilterChip('Stimulasi', 'Stimulasi', false),
                _buildFilterChip('Perawatan', 'Perawatan', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build filter chip
  Widget _buildFilterChip(String label, String? value, bool isCategory) {
    final isSelected =
        isCategory ? _selectedCategory == value : _selectedSubcategory == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isCategory) {
            _selectedCategory = _selectedCategory == value ? null : value;
          } else {
            _selectedSubcategory = _selectedSubcategory == value ? null : value;
          }
        });
        _performSearch();
      },
      child: Container(
        margin: const EdgeInsets.only(right: AppDimensions.spacingS),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Build results
  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (!_hasSearched) {
      return _buildEmptyState(
        icon: Icons.search_rounded,
        title: 'Mulai Pencarian',
        subtitle: 'Ketik kata kunci atau pilih filter',
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off_rounded,
        title: 'Tidak Ada Hasil',
        subtitle: 'Coba kata kunci lain',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          child: Text(
            'Ditemukan ${_searchResults.length} materi',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return _buildResultCard(_searchResults[index]);
            },
          ),
        ),
      ],
    );
  }

  /// Build empty state - COMPACT VERSION
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
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
      ),
    );
  }

  /// Build result card
  Widget _buildResultCard(model.Material material) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialDetailScreen(material: material),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
        child: SimpleCard(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & subcategory tags
                Row(
                  children: [
                    // Age category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(material.category),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        material.categoryDisplay,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: AppDimensions.spacingS),

                    // Subcategory
                    Text(
                      material.subcategoryDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const Spacer(),

                    // Reading time
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${material.estimatedReadingTime} mnt',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacingM),

                // Title
                Text(
                  material.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppDimensions.spacingS),

                // Content preview
                Text(
                  material.contentPreview,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppDimensions.spacingM),

                // Tags
                if (material.tagList.isNotEmpty)
                  Wrap(
                    spacing: AppDimensions.spacingS,
                    runSpacing: AppDimensions.spacingS,
                    children:
                        material.tagList.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingS,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case '0-1':
        return const Color(0xFF42A5F5); // Blue
      case '1-2':
        return const Color(0xFF66BB6A); // Green
      case '2-5':
        return const Color(0xFFFFB74D); // Orange
      default:
        return AppColors.primary;
    }
  }
}
