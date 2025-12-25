class RecipeModel {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final int cookTime; // in minutes
  final String category;

  RecipeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.cookTime,
    required this.category,
  });

  // To convert Firestore data to our Model
  factory RecipeModel.fromMap(Map<String, dynamic> map, String id) {
    return RecipeModel(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: map['instructions'] ?? '',
      cookTime: map['cookTime'] ?? 0,
      category: map['category'] ?? 'General',
    );
  }
}
