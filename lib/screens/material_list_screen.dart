/// File: material_list_screen.dart
/// Path: lib/screens/material_list_screen.dart
/// Description: Screen untuk display list materi edukatif dengan filter
///
/// Features:
/// - Load materials from database
/// - Populate data on first run
/// - Filter by category (0-1, 1-2, 2-5 tahun)
/// - Filter by subcategory (Pertumbuhan, Perkembangan, Nutrisi, Stimulasi, Perawatan)
/// - Persistent bookmarks (save to database)
/// - Pull to refresh
/// - Empty state

import 'package:flutter/material.dart';
import '../models/material.dart' as model;
import '../widgets/material_list_item.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import '../services/database_service.dart';
import '../utils/helpers/populate_materials.dart';
import 'material_detail_screen.dart';

class MaterialListScreen extends StatefulWidget {
  const MaterialListScreen({super.key});

  @override
  State<MaterialListScreen> createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  final DatabaseService _dbService = DatabaseService();
  final PopulateMaterials _populator = PopulateMaterials();

  // Filter states
  String _selectedCategory = 'Semua'; // Semua, 0-1, 1-2, 2-5
  String _selectedSubcategory =
      'Semua'; // Semua, Pertumbuhan, Perkembangan, dll

  // Data states
  List<model.Material> _allMaterials = [];
  Set<int> _bookmarkedIds = {};
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize database and load data
  Future<void> _initializeData() async {
    // CRITICAL: Prevent multiple initialization
    if (_isInitialized) {
      print('⚠️ Already initialized, skipping...');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔄 Initializing MaterialListScreen...');

      // 1. Populate database on first run
      await _populator.populateAll();

      // 2. Load all materials from database
      await _loadMaterials();

      // 3. Load bookmarked IDs
      await _loadBookmarks();

      setState(() {
        _isInitialized = true;
      });

      print('✅ MaterialListScreen initialized successfully');
    } catch (e) {
      print('❌ Error initializing: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Load all materials from database
  Future<void> _loadMaterials() async {
    try {
      List<Map<String, dynamic>> materialsData;

      if (_selectedCategory == 'Semua') {
        // Get ALL materials from all categories
        materialsData = [];
        materialsData.addAll(await _dbService.getMaterialsByCategory('0-1'));
        materialsData.addAll(await _dbService.getMaterialsByCategory('1-2'));
        materialsData.addAll(await _dbService.getMaterialsByCategory('2-5'));
      } else {
        // Get materials by specific category
        materialsData = await _dbService.getMaterialsByCategory(
          _selectedCategory,
        );
      }

      // Convert Map to Material objects
      final materials =
          materialsData.map((data) {
            return model.Material.fromMap(data);
          }).toList();

      setState(() {
        _allMaterials = materials;
      });

      print('✅ Loaded ${materials.length} materials');
    } catch (e) {
      print('❌ Error loading materials: $e');
      rethrow;
    }
  }

  /// Load bookmarked material IDs from database
  Future<void> _loadBookmarks() async {
    try {
      final bookmarks = await _dbService.getBookmarkedMaterials();

      setState(() {
        _bookmarkedIds = bookmarks.map((b) => b['id'] as int).toSet();
      });

      print('✅ Loaded ${_bookmarkedIds.length} bookmarks');
    } catch (e) {
      print('❌ Error loading bookmarks: $e');
    }
  }

  /// Get filtered materials based on selected filters
  List<model.Material> get _filteredMaterials {
    var materials = _allMaterials;

    // Filter by category
    if (_selectedCategory != 'Semua') {
      materials =
          materials.where((m) => m.category == _selectedCategory).toList();
    }

    // Filter by subcategory
    if (_selectedSubcategory != 'Semua') {
      materials =
          materials
              .where(
                (m) =>
                    m.subcategory.toLowerCase() ==
                    _selectedSubcategory.toLowerCase(),
              )
              .toList();
    }

    return materials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header / AppBar
              _buildAppBar(),

              // Filter Chips - Category
              _buildCategoryFilter(),

              // Filter Chips - Subcategory
              _buildSubcategoryFilter(),

              // Materials List
              Expanded(
                child:
                    _isLoading ? _buildLoadingState() : _buildMaterialsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build custom app bar
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          // Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Materi Edukatif', style: AppTextStyles.h2),
                SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Informasi tumbuh kembang anak',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),

          // Search icon (coming soon)
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur pencarian segera hadir!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build category filter chips
  Widget _buildCategoryFilter() {
    final categories = ['Semua', '0-1', '1-2', '2-5'];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
        itemCount: categories.length,
        separatorBuilder:
            (context, index) => const SizedBox(width: AppDimensions.spacingS),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return FilterChip(
            label: Text(
              category == 'Semua' ? category : '$category Tahun',
              style: AppTextStyles.label.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) async {
              setState(() {
                _selectedCategory = category;
                _selectedSubcategory = 'Semua'; // Reset subcategory
              });

              // Reload materials with new filter
              await _loadMaterials();
            },
            backgroundColor: AppColors.glassWhite,
            selectedColor: AppColors.primary,
            checkmarkColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.glassBorder,
              width: 1.5,
            ),
          );
        },
      ),
    );
  }

  /// Build subcategory filter chips
  Widget _buildSubcategoryFilter() {
    final subcategories = [
      'Semua',
      'Pertumbuhan',
      'Perkembangan',
      'Nutrisi',
      'Stimulasi',
      'Perawatan',
    ];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
        itemCount: subcategories.length,
        separatorBuilder:
            (context, index) => const SizedBox(width: AppDimensions.spacingS),
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          final isSelected = _selectedSubcategory == subcategory;

          return FilterChip(
            label: Text(
              subcategory,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedSubcategory = subcategory;
              });
            },
            backgroundColor: AppColors.glassWhite,
            selectedColor: AppColors.secondary,
            checkmarkColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.secondary : AppColors.glassBorder,
              width: 1.5,
            ),
          );
        },
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spacingM),
          Text('Memuat materi...', style: AppTextStyles.body2),
        ],
      ),
    );
  }

  /// Build materials list
  Widget _buildMaterialsList() {
    final materials = _filteredMaterials;

    // Empty state
    if (materials.isEmpty) {
      return _buildEmptyState();
    }

    // List with pull to refresh
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        itemCount: materials.length,
        separatorBuilder:
            (context, index) => const SizedBox(height: AppDimensions.spacingM),
        itemBuilder: (context, index) {
          final material = materials[index];
          return MaterialListItem(
            material: material,
            onTap: () => _onMaterialTap(material),
            showBookmark: true,
            isBookmarked: _bookmarkedIds.contains(material.id),
            onBookmarkTap: () => _onBookmarkTap(material),
          );
        },
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: AppDimensions.iconXXL,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          const Text('Belum ada materi', style: AppTextStyles.h4),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Coba ubah filter atau cek lagi nanti',
            style: AppTextStyles.body2.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Handle material tap
  void _onMaterialTap(model.Material material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MaterialDetailScreen(
              material: material,
              isBookmarked: _bookmarkedIds.contains(material.id),
              onBookmarkToggle: () => _onBookmarkTap(material),
            ),
      ),
    );
  }

  /// Handle bookmark tap - Save to database
  Future<void> _onBookmarkTap(model.Material material) async {
    final materialId = material.id;
    if (materialId == null) return;

    // Prevent double-tap issues
    final isCurrentlyBookmarked = _bookmarkedIds.contains(materialId);

    try {
      if (isCurrentlyBookmarked) {
        // Optimistic update - update UI first
        setState(() {
          _bookmarkedIds.remove(materialId);
        });

        // Then update database
        await _dbService.removeBookmark(materialId);

        print('✅ Bookmark removed: $materialId');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bookmark dihapus'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        // Optimistic update - update UI first
        setState(() {
          _bookmarkedIds.add(materialId);
        });

        // Then update database
        await _dbService.addBookmark(materialId);

        print('✅ Bookmark added: $materialId');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ditambahkan ke bookmark'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error toggling bookmark: $e');

      // Rollback on error
      setState(() {
        if (isCurrentlyBookmarked) {
          _bookmarkedIds.add(materialId);
        } else {
          _bookmarkedIds.remove(materialId);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Gagal menyimpan bookmark'),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Handle pull to refresh
  Future<void> _onRefresh() async {
    try {
      print('🔄 Refreshing data...');

      // Only reload bookmarks, materials already loaded
      await _loadBookmarks();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data telah diperbarui'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      print('✅ Refresh complete');
    } catch (e) {
      print('❌ Error refreshing: $e');
    }
  }
}
