import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  final List<String> _bookmark = [];
  List<String> get listReponse => _bookmark;

  void toggleBookmark(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final isExit = _bookmark.contains(item);
    print(item);
    await prefs.setString('saveBookmark', item);
    if (isExit) {
      _bookmark.remove(item);
    } else {
      _bookmark.add(item);
    }
    notifyListeners();
  }

  bool isExist(String item) {
    final isExit = _bookmark.contains(item);
    return isExit;
  }

  // void clearBookmark() {
  //   final _bookmark = [];
  //   notifyListeners();
  // }
}
