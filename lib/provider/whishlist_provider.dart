// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_final_fields
import 'package:hive/hive.dart';

import 'package:flutter/cupertino.dart';


@HiveType(typeId: 1)
class Whishlist extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String image;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final double price;

  // final Color color;
  Whishlist({
    // required this.productId,
    required this.image,
    required this.title,
    required this.price,
    required this.id,
  });

  Whishlist copyWith({
    String? id,
    String? image,
    String? title,
    double? price,
  }) {
    return Whishlist(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      price: price ?? this.price,
    );
  }
}

class WhishlistProvider with ChangeNotifier {
  Map<String, Whishlist> _whishlist = {};
  Map<String, Whishlist> get whishlist => _whishlist;

  void addOrRemoveWish(String title, String id, String image, double price) {
    if (_whishlist.containsKey(id)) {
      removeItem(id);
      // print(id);
    } else {
      // print(id);

      _whishlist.putIfAbsent(
        id,
        () => Whishlist(
          id: id,
          image: image,
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _whishlist.remove(id);
    notifyListeners();
  }

  void clearWish() {
    _whishlist.clear();
    notifyListeners();
  }
}
