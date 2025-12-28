import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/recipe_model.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a recipe
  Future<void> addRecipe(RecipeModel recipe) async {
    await _firestore.collection('recipes').doc(recipe.id).set(recipe.toMap());
  }

  // Fetch recipes by category
  Stream<List<RecipeModel>> getRecipesByCategory(String categoryName) {
    return _firestore
        .collection('recipes')
        .where('category', isEqualTo: categoryName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Optional: Fetch all recipes
  Stream<List<RecipeModel>> getAllRecipes() {
    return _firestore
        .collection('recipes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<RecipeModel>> getRecipesByIds(List<String> ids) {
    return _firestore
        .collection('recipes')
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
