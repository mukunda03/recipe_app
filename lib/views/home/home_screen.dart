import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/screen_size.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/providers/current_user_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/views/recipes/recipe_details/recipe_detail_screen.dart';
import 'package:recipe_app/views/settings/setting_screen.dart';
import 'package:recipe_app/widgets/category_main_card.dart';
import 'package:recipe_app/widgets/recipe_main_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _pageController;
  final int initialPage = 1000;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final categoryAsync = ref.watch(categoryProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              userAsync.when(
                data: (user) {
                  if (user == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${user.fullName.split(' ').first} 👋",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Welcome back!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SettingScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primartTeal,
                            child: Text(
                              user.fullName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // 🔹 Categories Carousel
              SizedBox(
                height: screenSize(context).height * 0.5,
                child: categoryAsync.when(
                  data: (categories) {
                    final total = categories.length;
                    return Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final category = categories[index % total];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: CategoryCard(
                                  title: category.name,
                                  description: category.description,
                                  imageUrl: category.imageUrl,
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: categories.length,
                          effect: WormEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            spacing: 8,
                            dotColor: Colors.grey.shade300,
                            activeDotColor: AppColors.primartTeal,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: SpinKitCircle(color: AppColors.primartTeal),
                  ),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Recipes by Category
              categoryAsync.when(
                data: (categories) {
                  return Column(
                    children: categories.map((category) {
                      final recipesAsync = ref.watch(
                        recipesByCategoryProvider(category.name),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 180,
                            child: recipesAsync.when(
                              data: (recipes) {
                                if (recipes.isEmpty) {
                                  return const Center(
                                    child: Text("No recipes found"),
                                  );
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recipes.length,
                                  itemBuilder: (context, index) {
                                    final recipe = recipes[index];
                                    return RecipeMainCard(
                                      title: recipe.title,
                                      imageUrl: recipe.imageUrl,
                                      cookTime: recipe.cookTime,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RecipeDetailScreen(
                                              recipe: recipe,
                                            ),
                                          ),
                                        );
                                      },
                                      calories: recipe.calories,
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: SpinKitCircle(
                                  color: AppColors.primartTeal,
                                ),
                              ),
                              error: (e, _) =>
                                  Center(child: Text(e.toString())),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: SpinKitCircle(color: AppColors.primartTeal),
                ),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
