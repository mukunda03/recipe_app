import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/category_model.dart';

final categoryProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('categories')
      .get();

  return snapshot.docs
      .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
      .toList();
});
