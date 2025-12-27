import 'package:cloud_firestore/cloud_firestore.dart';
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

final recipeProvider = StreamProvider((ref) {
  return FirebaseFirestore.instance
      .collection('recipes')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
            .toList(),
      );
});
