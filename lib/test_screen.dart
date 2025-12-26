import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/category_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestCategoryScreen extends ConsumerWidget {
  const TestCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: categoryAsync.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: Image.network(
                category.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(category.name),
              subtitle: Text(category.description),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> seedRecipes() async {
  final categories = [
    'Healthy',
    'Vegan',
    'Quick Bites',
    'Desserts',
    'Breakfast',
  ];

  final Map<String, List<Map<String, dynamic>>> recipeData = {
    'Healthy': [
      {
        'title': 'Grilled Chicken Salad',
        'imageUrl':
            'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?q=80&w=1013&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 20,
        'ingredients': [
          'Chicken',
          'Lettuce',
          'Tomatoes',
          'Cucumber',
          'Olive oil',
        ],
        'instructions': 'Grill chicken, mix veggies, toss with olive oil.',
        'description':
            'High protein salad with grilled chicken and fresh veggies.',
        'calories': 320,
      },
      {
        'title': 'Quinoa Salad',
        'imageUrl':
            'https://plus.unsplash.com/premium_photo-1705207702013-368450377046?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 15,
        'ingredients': ['Quinoa', 'Bell peppers', 'Corn', 'Avocado'],
        'instructions': 'Cook quinoa, chop veggies, mix together.',
        'description': 'Fiber rich quinoa salad with colorful vegetables.',
        'calories': 280,
      },
      {
        'title': 'Avocado Toast',
        'imageUrl':
            'https://images.unsplash.com/photo-1628556820645-63ba5f90e6a2?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 10,
        'ingredients': ['Bread', 'Avocado', 'Salt', 'Lemon juice'],
        'instructions': 'Toast bread, mash avocado, spread on toast.',
        'description': 'Healthy fats from avocado on crispy toast.',
        'calories': 220,
      },
      {
        'title': 'Smoothie Bowl',
        'imageUrl':
            'https://plus.unsplash.com/premium_photo-1663840135654-b4119f34a720?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 5,
        'ingredients': ['Banana', 'Berries', 'Almond milk', 'Chia seeds'],
        'instructions': 'Blend fruits, pour in bowl, top with seeds.',
        'description': 'Refreshing fruit smoothie topped with seeds.',
        'calories': 200,
      },
    ],
    'Vegan': [
      {
        'title': 'Vegan Salad',
        'imageUrl':
            'https://images.unsplash.com/photo-1623428187969-5da2dcea5ebf?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 10,
        'ingredients': ['Lettuce', 'Tomatoes', 'Chickpeas', 'Olive oil'],
        'instructions': 'Mix all ingredients and serve.',
        'description': 'Plant-based salad packed with nutrients.',
        'calories': 180,
      },
      {
        'title': 'Vegan Smoothie',
        'imageUrl':
            'https://images.unsplash.com/photo-1749080143220-d308c07f80b0?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 5,
        'ingredients': ['Almond milk', 'Banana', 'Spinach', 'Berries'],
        'instructions': 'Blend all ingredients until smooth.',
        'description': 'Green smoothie loaded with vitamins.',
        'calories': 160,
      },
      {
        'title': 'Vegan Wrap',
        'imageUrl':
            'https://images.unsplash.com/photo-1592044903782-9836f74027c0?q=80&w=627&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 15,
        'ingredients': ['Tortilla', 'Hummus', 'Veggies'],
        'instructions': 'Spread hummus on tortilla, add veggies, roll.',
        'description': 'Quick vegan wrap with hummus and veggies.',
        'calories': 250,
      },
      {
        'title': 'Vegan Buddha Bowl',
        'imageUrl':
            'https://images.unsplash.com/photo-1702823394373-4a39bcb80c95?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 20,
        'ingredients': ['Rice', 'Tofu', 'Broccoli', 'Carrots', 'Sauce'],
        'instructions': 'Cook rice and tofu, steam veggies, assemble bowl.',
        'description': 'Balanced bowl with tofu, rice and vegetables.',
        'calories': 350,
      },
    ],
    'Quick Bites': [
      {
        'title': 'Burger',
        'imageUrl':
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 15,
        'ingredients': ['Burger bun', 'Patty', 'Lettuce', 'Cheese'],
        'instructions': 'Cook patty, assemble burger with toppings.',
        'description': 'Juicy burger perfect for quick hunger.',
        'calories': 450,
      },
      {
        'title': 'Pizza Slice',
        'imageUrl':
            'https://images.unsplash.com/photo-1593504049359-74330189a345?q=80&w=627&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 20,
        'ingredients': ['Pizza base', 'Tomato sauce', 'Cheese', 'Veggies'],
        'instructions': 'Spread sauce, add toppings, bake.',
        'description': 'Cheesy pizza slice with fresh toppings.',
        'calories': 380,
      },
      {
        'title': 'French Fries',
        'imageUrl':
            'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?q=80&w=1025&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 10,
        'ingredients': ['Potatoes', 'Salt', 'Oil'],
        'instructions': 'Cut potatoes, fry until golden, season with salt.',
        'description': 'Crispy golden fries with salt.',
        'calories': 300,
      },
      {
        'title': 'Tacos',
        'imageUrl':
            'https://plus.unsplash.com/premium_photo-1664476631037-87a2714dd04e?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 15,
        'ingredients': ['Taco shells', 'Meat', 'Lettuce', 'Cheese'],
        'instructions': 'Cook meat, assemble tacos with toppings.',
        'description': 'Mexican style tacos filled with flavor.',
        'calories': 420,
      },
    ],
    'Desserts': [
      {
        'title': 'Chocolate Cake',
        'imageUrl':
            'https://images.unsplash.com/photo-1605807646983-377bc5a76493?q=80&w=1024&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 60,
        'ingredients': ['Flour', 'Cocoa', 'Sugar', 'Eggs', 'Butter'],
        'instructions': 'Mix ingredients, bake at 180°C for 40 mins.',
        'description': 'Rich and moist chocolate cake.',
        'calories': 520,
      },
      {
        'title': 'Ice Cream',
        'imageUrl':
            'https://images.unsplash.com/photo-1560008581-09826d1de69e?q=80&w=744&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 10,
        'ingredients': ['Milk', 'Sugar', 'Vanilla', 'Cream'],
        'instructions': 'Mix ingredients, freeze until solid.',
        'description': 'Cold creamy dessert for sweet cravings.',
        'calories': 270,
      },
      {
        'title': 'Brownies',
        'imageUrl':
            'https://plus.unsplash.com/premium_photo-1716152295675-595f7a5a1d54?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 35,
        'ingredients': ['Chocolate', 'Flour', 'Sugar', 'Eggs', 'Butter'],
        'instructions': 'Mix ingredients, bake at 180°C for 25 mins.',
        'description': 'Fudgy chocolate brownies.',
        'calories': 430,
      },
      {
        'title': 'Cupcakes',
        'imageUrl':
            'https://images.unsplash.com/photo-1519869325930-281384150729?q=80&w=1166&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 30,
        'ingredients': ['Flour', 'Sugar', 'Eggs', 'Butter', 'Frosting'],
        'instructions': 'Prepare batter, bake, decorate with frosting.',
        'description': 'Soft cupcakes topped with frosting.',
        'calories': 360,
      },
    ],
    'Breakfast': [
      {
        'title': 'Pancakes',
        'imageUrl':
            'https://images.unsplash.com/photo-1528207776546-365bb710ee93?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 20,
        'ingredients': ['Flour', 'Eggs', 'Milk', 'Sugar', 'Butter'],
        'instructions': 'Mix ingredients, cook on skillet until golden.',
        'description': 'Fluffy pancakes perfect for mornings.',
        'calories': 350,
      },
      {
        'title': 'Omelette',
        'imageUrl':
            'https://plus.unsplash.com/premium_photo-1667807521536-bc35c8d8b64b?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 10,
        'ingredients': ['Eggs', 'Salt', 'Pepper', 'Veggies'],
        'instructions': 'Beat eggs, cook with veggies on pan.',
        'description': 'Protein-rich egg omelette.',
        'calories': 210,
      },
      {
        'title': 'French Toast',
        'imageUrl':
            'https://images.unsplash.com/photo-1484723091739-30a097e8f929?q=80&w=749&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 15,
        'ingredients': ['Bread', 'Eggs', 'Milk', 'Sugar', 'Cinnamon'],
        'instructions': 'Dip bread in egg mix, cook on skillet.',
        'description': 'Sweet toasted bread soaked in egg mix.',
        'calories': 330,
      },
      {
        'title': 'Smoothie Bowl',
        'imageUrl':
            'https://plus.unsplash.com/premium_photo-1663840135654-b4119f34a720?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'cookTime': 5,
        'ingredients': ['Banana', 'Berries', 'Almond milk', 'Chia seeds'],
        'instructions': 'Blend fruits, pour in bowl, top with seeds.',
        'description': 'Healthy breakfast smoothie bowl.',
        'calories': 240,
      },
    ],
  };

  try {
    for (final category in categories) {
      final recipes = recipeData[category]!;
      for (final recipe in recipes) {
        await _firestore.collection('recipes').add({
          'title': recipe['title'],
          'imageUrl': recipe['imageUrl'],
          'cookTime': recipe['cookTime'],
          'ingredients': recipe['ingredients'],
          'instructions': recipe['instructions'],
          'category': category, // foreign key
          'createdAt': FieldValue.serverTimestamp(),
          'description': recipe['description'],
          'calories': recipe['calories'],
        });
      }
    }

    print('✅ Successfully seeded recipes!');
  } catch (e) {
    print('❌ Error seeding recipes: $e');
  }
}
