import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/providers/fav_recipe_provider.dart';
import 'package:recipe_app/views/recipes/recipe_details/recipe_detail_screen.dart';

class RecipeMainCard extends ConsumerWidget {
  final RecipeModel recipe;

  const RecipeMainCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIdAsync = ref.watch(favoriteIdsProvider);

    return favIdAsync.when(
      data: (favId) {
        final isFav = favId.contains(recipe.id);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: recipe),
              ),
            );
          },
          child: Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        recipe.imageUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () async {
                          final repo = ref.read(favoriteRepositoryProvider);
                          await repo.toggleFavorite(recipe);
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFav ? Colors.red : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recipe.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department_outlined, size: 12),
                      SizedBox(width: 5),
                      Text(
                        '${recipe.calories} kcal',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 12),
                      SizedBox(width: 5),
                      Text(
                        '${recipe.cookTime} mins',
                        style: TextStyle(color: Colors.grey),
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
