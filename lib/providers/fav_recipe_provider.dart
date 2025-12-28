import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/repositories/fav_recipe_repo.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Repository provider
final favoriteRepositoryProvider = Provider((ref) => FavoriteRepository());

// Favorite recipe IDs for current user
final favoriteIdsProvider = StreamProvider<List<String>>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return authAsync.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty(); // 🚫 NO FIRESTORE CALL
      }
      final repo = ref.watch(favoriteRepositoryProvider);
      return repo.getFavorites();
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final favoriteRecipesProvider = StreamProvider<List<RecipeModel>>((ref) {
  final favIdsAsync = ref.watch(favoriteIdsProvider);
  final repo = ref.watch(recipeRepositoryProvider);

  return favIdsAsync.when(
    data: (ids) {
      if (ids.isEmpty) {
        return Stream.value([]);
      }
      return repo.getRecipesByIds(ids);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});




/// Try this if above code doesn't work 
/*
// Provider for repository
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepository();
});

// StreamProvider for current user's favorite recipe IDs
final favoriteIdsProvider = StreamProvider<List<String>>((ref) {
  final auth = ref.watch(authStateProvider).value; // Using your auth provider
  if (auth == null) return const Stream.empty();

  final repo = ref.watch(favoriteRepositoryProvider);
  return repo.getFavorites();
});
*/