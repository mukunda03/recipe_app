import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/models/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //  Image AppBar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
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
                              style: TextStyle(color: AppColors.primartTeal),
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
                            child: Text(item, style: TextStyle(fontSize: 18)),
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
      ),
    );
  }
}
