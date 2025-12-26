class RecipeModel {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final int cookTime;
  final String category;
  final String description;
  final int calories;

  RecipeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.cookTime,
    required this.category,
    required this.description,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookTime': cookTime,
      'category': category,
      'description': description,
      'calories': calories,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map, String id) {
    return RecipeModel(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: map['instructions'] ?? '',
      cookTime: map['cookTime'] ?? 0,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      calories: map['calories'] ?? 0,
    );
  }
}
