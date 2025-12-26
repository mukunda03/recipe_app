import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository();
});

final recipesByCategoryProvider =
    StreamProvider.family<List<RecipeModel>, String>((ref, categoryName) {
      final repo = ref.watch(recipeRepositoryProvider);
      return repo.getRecipesByCategory(categoryName);
    });
