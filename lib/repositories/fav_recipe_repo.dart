import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Get user favorites
  Stream<List<String>> getFavorites() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((s) => s.docs.map((d) => d.id).toList());
  }

  // Toggle favorite
  Future<void> toggleFavorite(RecipeModel recipe) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(recipe.id);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }

  // Check if recipe is favorite
  Future<bool> isFavorite(RecipeModel recipe) async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(recipe.id)
        .get();
    return doc.exists;
  }

  void removeFavorite(String id) {}
}
