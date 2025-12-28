import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/text_styles.dart';
import 'package:recipe_app/models/category_model.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/providers/fav_recipe_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/providers/search_text_provider.dart';
import 'package:recipe_app/views/recipes/recipe_details/recipe_detail_screen.dart';

class DiscoveryPage extends ConsumerWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final recipesAsync = ref.watch(recipeProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchText = ref.watch(searchTextProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Text(
                'Discover',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Find the best recipes for you',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),
              _searchBar(ref),
              const SizedBox(height: 20),

              ///  Categories
              categoriesAsync.when(
                data: (categories) {
                  final allCategories = [
                    CategoryModel(
                      name: 'All',
                      id: 'all',
                      imageUrl: '',
                      description: '',
                    ),
                    ...categories,
                  ];
                  return _categorySection(allCategories, ref);
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              const SizedBox(height: 16),

              ///  TITLE
              const Text(
                'Popular Recipes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ///  RECIPES GRID (ONLY THIS SCROLLS)
              Expanded(
                child: recipesAsync.when(
                  data: (recipes) {
                    final filteredRecipes = recipes.where((recipe) {
                      final matchesCategory =
                          selectedCategory == 'All' ||
                          recipe.category == selectedCategory;

                      final matchesSearch = recipe.title.toLowerCase().contains(
                        searchText.toLowerCase(),
                      );

                      return matchesCategory && matchesSearch;
                    }).toList();

                    if (filteredRecipes.isEmpty) {
                      return const Center(child: Text("No recipes found 😔"));
                    }

                    return _recipeGrid(filteredRecipes, ref);
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(e.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          ref.read(searchTextProvider.notifier).state = value;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search recipes...',
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _categorySection(List<CategoryModel> categories, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat.name;

          return ChoiceChip(
            label: Text(cat.name),
            selected: isSelected,
            onSelected: (_) {
              ref.read(selectedCategoryProvider.notifier).state = cat.name;
            },
            selectedColor: AppColors.primartTeal,
            backgroundColor: Colors.grey.shade200,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  Widget _recipeGrid(List<RecipeModel> recipes, WidgetRef ref) {
    return GridView.builder(
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return _recipeCard(
          recipe: recipes[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: recipes[index]),
              ),
            );
          },
          ref: ref,
        );
      },
    );
  }

  Widget _recipeCard({
    required RecipeModel recipe,
    required VoidCallback onTap,
    required WidgetRef ref,
  }) {
    final favIdAsync = ref.watch(favoriteIdsProvider);

    return favIdAsync.when(
      data: (favId) {
        final isFavorite = favId.contains(recipe.id);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 IMAGE + FAVORITE ICON
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      // Favorite icon at top-right
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            final repo = ref.read(favoriteRepositoryProvider);
                            await repo.toggleFavorite(recipe);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Recipe info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: TextStyles.h3(AppColors.textDark),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.calories} kcal',
                            style: TextStyle(color: AppColors.primartTeal),
                          ),
                          const Spacer(),
                          const Icon(Icons.timer, size: 14),
                          const SizedBox(width: 4),
                          Text('${recipe.cookTime} min'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, _) => Center(child: Text(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
