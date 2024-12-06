import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:phone_call_app/modal/notification_serviice.dart';
import 'package:phone_call_app/view/calling_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneProvider with ChangeNotifier {
  String dialedNumber = '';
  final TextEditingController numberController = TextEditingController();

  void appendDigit(String digit) {
    numberController.text += digit;
    notifyListeners();
  }

  void deleteLastDigit() {
    if (numberController.text.isNotEmpty) {
      numberController.text =
          numberController.text.substring(0, numberController.text.length - 1);
      notifyListeners();
    }
  }

  Future<void> makeCall(BuildContext context) async {
    final String phoneNumber = numberController.text;

    if (phoneNumber.isNotEmpty) {
      log('Dialing number: $phoneNumber');
      await addToCallLog(phoneNumber, 'Outgoing');
      numberController.clear();
      notifyListeners();
      await fetchCallLogs();
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallingScreen(
                  phoneno: phoneNumber,
                )),
      );
      await NotificationHelper.showNotification(
        "Meeting Joined",
        "You have joined the meeting:",
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number!')),
      );
    }
  }

  Future<void> addToCallLog(String number, String callType) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> callLogs = prefs.getStringList('callLogs') ?? [];

    Map<String, String> callDetails = {
      'number': number,
      'type': callType,
      'timestamp': DateTime.now().toIso8601String(),
    };

    callLogs.add(jsonEncode(callDetails));
    await prefs.setStringList('callLogs', callLogs);
    log('Added to call log: ${callLogs.toString()}');
  }

  // Manage call logs
  List<Map<String, String>> _callLogs = [];
  bool _isLoading = false;

  List<Map<String, String>> get callLogs => _callLogs;
  bool get isLoading => _isLoading;

  Future<void> fetchCallLogs() async {
    log('logs calling');
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    List<String> callLogs = prefs.getStringList('callLogs') ?? [];
    _callLogs = callLogs
        .map((log) => Map<String, String>.from(jsonDecode(log)))
        .toList();

    _isLoading = false;
    notifyListeners();
  }
}
