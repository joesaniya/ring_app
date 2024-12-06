import 'package:flutter/material.dart';
import 'package:phone_call_app/view/call_logs.dart';
import 'package:phone_call_app/view/contacts_screen.dart';
import 'package:phone_call_app/view/phone_screen.dart';

class BottomProvider with ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> screens = [
    PhoneScreen(),
    ContactsScreen(),
    CallLogScreen()
  ];

  void onItemTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
