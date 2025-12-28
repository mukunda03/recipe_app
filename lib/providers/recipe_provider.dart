import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository();
});

final recipesByCategoryProvider1 =
    StreamProvider.family<List<RecipeModel>, String>((ref, categoryName) {
      final repo = ref.watch(recipeRepositoryProvider);
      return repo.getRecipesByCategory(categoryName);
    });

final recipeProvider1 = StreamProvider((ref) {
  return FirebaseFirestore.instance
      .collection('recipes')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
            .toList(),
      );
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final recipesByCategoryProvider =
    StreamProvider.family<List<RecipeModel>, String>((ref, category) {
      final auth = ref.watch(authStateProvider).value;

      if (auth == null) {
        return const Stream.empty(); // 🔥 THIS FIXES ERROR
      }

      final repo = ref.watch(recipeRepositoryProvider);
      return repo.getRecipesByCategory(category);
    });

final recipeProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final snapshot = await FirebaseFirestore.instance.collection('recipes').get();

  return snapshot.docs
      .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
      .toList();
});
