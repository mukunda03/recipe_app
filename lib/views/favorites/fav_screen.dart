import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/text_styles.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/providers/fav_recipe_provider.dart';
import 'package:recipe_app/views/recipes/recipe_details/recipe_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteRecipesProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                'No favorite recipes yet ❤️',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return _favoriteCard(recipes[index], ref, context);
            },
          );
        },
      ),
    );
  }

  Widget _favoriteCard(
    RecipeModel recipe,
    WidgetRef ref,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
              child: Image.network(
                recipe.imageUrl,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyles.h3(AppColors.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(recipe.category, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.cookTime} min',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            ref
                                .read(favoriteRepositoryProvider)
                                .removeFavorite(recipe.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
