import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/providers/fav_recipe_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIdAsync = ref.watch(favoriteIdsProvider);

    return Scaffold(
      body: favIdAsync.when(
        data: (favId) {
          final isFav = favId.contains(recipe.id);

          return CustomScrollView(
            slivers: [
              //  Image AppBar
              SliverAppBar(
                expandedHeight: 280,
                floating: true,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.black,
                        ),
                        onPressed: () async {
                          final repo = ref.read(favoriteRepositoryProvider);
                          await repo.toggleFavorite(recipe);
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(''),
                  background: Image.network(recipe.imageUrl, fit: BoxFit.cover),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: TextStyle(
                          color: AppColors.primartTeal,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        recipe.category,
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      Text(
                        recipe.description,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 22,
                                color: AppColors.primartTeal,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Cooking Time",
                                style: TextStyle(color: AppColors.primartTeal),
                              ),
                              Text('${recipe.cookTime} mins'),
                            ],
                          ),

                          ...[
                            Column(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  size: 27,
                                  color: AppColors.primartTeal,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Calories",
                                  style: TextStyle(
                                    color: AppColors.primartTeal,
                                  ),
                                ),
                                Text('${recipe.calories} cal'),
                              ],
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 24),

                      Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primartTeal,
                        ),
                      ),
                      SizedBox(height: 8),

                      ...recipe.ingredients.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_right_outlined,
                                size: 24,
                                color: AppColors.primartTeal,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Instructions
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primartTeal,
                        ),
                      ),
                      SizedBox(height: 8),

                      Text(
                        recipe.instructions,
                        style: TextStyle(fontSize: 18, height: 1.5),
                      ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (e, _) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
