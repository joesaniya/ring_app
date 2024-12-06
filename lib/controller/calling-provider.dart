import 'package:flutter/material.dart';

class CallingProvider extends ChangeNotifier {
  void loadData() {
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      notifyListeners();
    });
  }
   void goback(BuildContext context) {
    Navigator.pop(context);
    notifyListeners();

   
  }
}
