import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/text_form_field.dart';
import 'package:recipe_app/core/constants/text_styles.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';

void showAddRecipeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddRecipeBottomSheet(),
  );
}

class _AddRecipeBottomSheet extends ConsumerStatefulWidget {
  const _AddRecipeBottomSheet();

  @override
  ConsumerState<_AddRecipeBottomSheet> createState() =>
      _AddRecipeBottomSheetState();
}

class _AddRecipeBottomSheetState extends ConsumerState<_AddRecipeBottomSheet> {
  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  final cookTimeController = TextEditingController();
  final descriptionController = TextEditingController();
  final caloriesController = TextEditingController();

  String? selectedCategory;

  final _addRecipeFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = "Masala Corn";
    imageUrlController.text =
        "https://www.vegrecipesofindia.com/wp-content/uploads/2016/08/masala-corn.jpg";
    cookTimeController.text = "10";
    caloriesController.text = "220";
    descriptionController.text =
        "Spicy and tangy masala corn made in minutes. Perfect evening snack.";
    ingredientsController.text =
        "Sweet corn, Butter, Red chilli Powder, Chat masala, Lemon Juice, Salt, Coriander leaves";
    instructionsController.text =
        "Boil sweet corn until soft. Heat butter, add corn, salt, chilli powder and chat masala. Toss well and finish with lemon juice and coriander. Serve hot.";
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            _header(),
            Expanded(
              child: categoriesAsync.when(
                data: (categories) {
                  // selectedCategory ??= categories.first.name;
                  return _form(categories.map((c) => c.name).toList());
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Text('Add New Recipe', style: TextStyles.h1(AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _form(List<String> categories) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: Form(
        key: _addRecipeFormKey,
        child: Column(
          children: [
            //Title
            CustomTextFormField(
              controller: titleController,
              hintText: 'Title',
              labelText: 'Title',
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Title";
                }
                return null;
              },
            ),
            //Image URL
            CustomTextFormField(
              controller: imageUrlController,
              hintText: 'Image URL',
              labelText: 'Image URL',
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Image Url";
                }
                return null;
              },
            ),
            //Categories
            _dropdown(categories),
            //Cook Time
            CustomTextFormField(
              controller: cookTimeController,
              hintText: 'Cook Time(min)',
              labelText: 'Cook Time(min)',
              keyboardType: TextInputType.number,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Cook Time";
                }
                return null;
              },
            ),
            //Calories
            CustomTextFormField(
              controller: caloriesController,
              hintText: 'Calories',
              labelText: 'Calories',
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Calories";
                }
                return null;
              },
            ),
            //Short Description
            CustomTextFormField(
              controller: descriptionController,
              hintText: 'Short Description',
              labelText: 'Short Description',
              maxLines: 2,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Short Description";
                }
                return null;
              },
            ),
            //Ingredients
            CustomTextFormField(
              controller: ingredientsController,
              hintText: 'Ingredients (comma separated)',
              labelText: 'Ingredients (comma separated)',
              maxLines: 3,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Ingredients";
                }
                return null;
              },
            ),
            //Instructions
            CustomTextFormField(
              controller: instructionsController,
              hintText: 'Instructions',
              labelText: 'Instructions',
              maxLines: 4,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Instructions";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Select a Category";
          }
          return null;
        },

        decoration: InputDecoration(
          labelText: 'Category',
          hintText: 'Category',
          counterText: '',
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1.2),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primartTeal, width: 2),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),

          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        items: categories
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (v) => setState(() => selectedCategory = v),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primartTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            if (_addRecipeFormKey.currentState!.validate()) {
              _submit();
            }
          }, //_submit,
          child: const Text(
            'Add Recipe',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final repo = ref.read(recipeRepositoryProvider);

    if (titleController.text.isEmpty ||
        imageUrlController.text.isEmpty ||
        cookTimeController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        selectedCategory == null) {
      return; // you can show snackbar later
    }

    final recipe = RecipeModel(
      id: FirebaseFirestore.instance.collection('recipes').doc().id,
      title: titleController.text.trim(),
      imageUrl: imageUrlController.text.trim(),
      category: selectedCategory!,
      cookTime: int.parse(cookTimeController.text),
      calories: int.parse(caloriesController.text),
      description: descriptionController.text.trim(),
      ingredients: ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .toList(),
      instructions: instructionsController.text.trim(),
    );

    print("ADDED RECIPE : ${recipe.toString()}");

    await repo.addRecipe(recipe);

    Navigator.pop(context);
  }
}
