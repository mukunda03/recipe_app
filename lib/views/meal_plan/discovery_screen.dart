import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SEARCH BAR
              TextField(
                decoration: InputDecoration(
                  hintText: "Search recipes...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primartTeal,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. CATEGORIES (Horizontal List)
              // SizedBox(
              //   height: 40,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: categories.length,
              //     itemBuilder: (context, index) {
              //       bool isSelected = selectedCategory == categories[index]['name'];
              //       return GestureDetector(
              //         onTap: () => setState(() => selectedCategory = categories[index]['name']),
              //         child: Container(
              //           margin: const EdgeInsets.only(right: 10),
              //           padding: const EdgeInsets.symmetric(horizontal: 20),
              //           decoration: BoxDecoration(
              //             color: isSelected ? AppColors.primaryTeal : Colors.white,
              //             borderRadius: BorderRadius.circular(20),
              //             border: Border.all(color: AppColors.primaryTeal.withOpacity(0.1)),
              //           ),
              //           child: Center(
              //             child: Text(
              //               categories[index]['name'],
              //               style: TextStyle(
              //                 color: isSelected ? AppColors.accentGold : AppColors.primaryTeal,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // const SizedBox(height: 20),

              // 3. RECIPE GRID (We will connect this to Firestore next)
              const Expanded(
                child: Center(child: Text("Recipe Grid will appear here")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
