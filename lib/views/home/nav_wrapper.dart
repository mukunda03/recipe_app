import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/providers/nav_provider.dart';
import 'package:recipe_app/views/home/nav_item.dart';
import 'package:recipe_app/views/favorites/fav_screen.dart';
import 'package:recipe_app/views/home/home_screen.dart';
import 'package:recipe_app/views/discovery/discovery_screen.dart';
import 'package:recipe_app/views/recipes/add_recipe/add_recipe_screen.dart';
import 'package:recipe_app/views/settings/setting_screen.dart';
// import 'package:recipe_app/views/settings/setting_screen.dart';

class MainNavigationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const DiscoveryPage(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddRecipeBottomSheet(context);
        },
        backgroundColor: AppColors.primartTeal,
        child: Icon(Icons.add, color: AppColors.accentGold),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // LEFT SIDE (2 icons)
              NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 0,
              ),
              NavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Discovery',
                index: 1,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 1,
              ),

              // CENTER SPACE FOR FAB
              const SizedBox(width: 48),

              // RIGHT SIDE (2 icons)
              NavItem(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                label: 'Favorites',
                index: 2,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 2,
              ),
              NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                index: 3,
                selectedIndex: selectedIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
