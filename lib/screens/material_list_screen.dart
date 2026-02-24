import 'package:flutter/material.dart';
import '../models/material.dart' as model;
import '../widgets/material_list_item.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../services/database_service.dart';
import '../utils/helpers/populate_materials.dart';
import 'material_detail_screen.dart';
import 'material_search_screen.dart';

class MaterialListScreen extends StatefulWidget {
  final String? initialCategory;
  const MaterialListScreen({super.key, this.initialCategory});

  @override
  State<MaterialListScreen> createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  final DatabaseService _dbService = DatabaseService();
  final PopulateMaterials _populator = PopulateMaterials();

  String _selectedCategory = 'Semua';
  List<model.Material> _allMaterials = [];
  Set<int> _bookmarkedIds = {};
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_isInitialized) return;
    setState(() => _isLoading = true);
    try {
      await _populator.populateAll();
      await _loadMaterials();
      await _loadBookmarks();
      setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMaterials() async {
    List<Map<String, dynamic>> materialsData = [];
    if (_selectedCategory == 'Semua') {
      materialsData.addAll(await _dbService.getMaterialsByCategory('0-1'));
      materialsData.addAll(await _dbService.getMaterialsByCategory('1-2'));
      materialsData.addAll(await _dbService.getMaterialsByCategory('2-5'));
    } else {
      materialsData = await _dbService.getMaterialsByCategory(
        _selectedCategory,
      );
    }
    setState(() {
      _allMaterials =
          materialsData.map((d) => model.Material.fromMap(d)).toList();
    });
  }

  Future<void> _loadBookmarks() async {
    try {
      final bookmarks = await _dbService.getBookmarkedMaterials();
      setState(
        () => _bookmarkedIds = bookmarks.map((b) => b['id'] as int).toSet(),
      );
    } catch (e) {
      // silent
    }
  }

  List<model.Material> get _filteredMaterials {
    var materials = _allMaterials;
    if (_selectedCategory != 'Semua') {
      materials =
          materials.where((m) => m.category == _selectedCategory).toList();
    }
    return materials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: _isLoading ? _buildLoadingState() : _buildMaterialsList(),
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Row(
            children: [
              if (Navigator.canPop(context))
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.initialCategory != null
                          ? 'Materi ${widget.initialCategory} Tahun'
                          : 'Materi Edukatif',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Informasi tumbuh kembang anak',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaterialSearchScreen(),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['Semua', '0-1', '1-2', '2-5'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = _selectedCategory == cat;
            final color =
                cat == 'Semua' ? AppColors.primary : _categoryColor(cat);
            return GestureDetector(
              onTap: () async {
                setState(() {
                  _selectedCategory = cat;
                });
                await _loadMaterials();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      cat == 'Semua' ? cat : '$cat Tahun',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text('Memuat materi...', style: AppTextStyles.body2),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    final materials = _filteredMaterials;
    if (materials.isEmpty) return _buildEmptyState();
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: materials.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final material = materials[index];
          return MaterialListItem(
            material: material,
            index: index,
            onTap: () => _onMaterialTap(material),
            showBookmark: true,
            isBookmarked: _bookmarkedIds.contains(material.id),
            onBookmarkTap: () => _onBookmarkTap(material),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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
            child: const Icon(
              Icons.article_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada materi', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            'Coba ubah filter atau cek lagi nanti',
            style: AppTextStyles.body2.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case '0-1':
        return AppColors.accentTeal;
      case '1-2':
        return AppColors.accentYellow;
      case '2-5':
        return AppColors.accentPurple;
      default:
        return AppColors.primary;
    }
  }

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

  Future<void> _onBookmarkTap(model.Material material) async {
    final materialId = material.id;
    if (materialId == null) return;
    final isBookmarked = _bookmarkedIds.contains(materialId);
    try {
      setState(() {
        if (isBookmarked) {
          _bookmarkedIds.remove(materialId);
        } else {
          _bookmarkedIds.add(materialId);
        }
      });
      if (isBookmarked) {
        await _dbService.removeBookmark(materialId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bookmark dihapus'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        await _dbService.addBookmark(materialId);
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
      setState(() {
        if (isBookmarked) {
          _bookmarkedIds.add(materialId);
        } else {
          _bookmarkedIds.remove(materialId);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menyimpan bookmark'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    try {
      await _loadBookmarks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data telah diperbarui'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // silent
    }
  }
}
