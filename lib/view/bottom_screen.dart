import 'package:flutter/material.dart';
import 'package:phone_call_app/controller/bottom_controller.dart';
import 'package:provider/provider.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  late BottomProvider controller;
  @override
  void initState() {
    super.initState();

    controller = BottomProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomProvider>(builder: (context, provider, _) {
      return Scaffold(
        body: provider.screens[provider.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.currentIndex,
          onTap: provider.onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              label: 'Phone',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_made),
              label: 'Incoming',
            ),
          ],
        ),
      );
    });
  }
}
