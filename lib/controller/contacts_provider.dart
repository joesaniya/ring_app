import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:phone_call_app/controller/phone_provider.dart';
import 'package:phone_call_app/modal/notification_serviice.dart';
import 'package:phone_call_app/view/calling_screen.dart';

class ContactProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _permissionGranted = false;
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = "";

  bool get isLoading => _isLoading;
  bool get permissionGranted => _permissionGranted;
  List<Contact> get contacts => _filteredContacts;

  ContactProvider() {
    _loadPermissionState();
  }

  // Load permission state from SharedPreferences
  Future<void> _loadPermissionState() async {
    final prefs = await SharedPreferences.getInstance();
    _permissionGranted = prefs.getBool('permissionGranted') ?? false;
    if (_permissionGranted) {
      await fetchContacts();
    }
    notifyListeners();
  }

  // Save permission state to SharedPreferences
  Future<void> _savePermissionState(bool isGranted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissionGranted', isGranted);
  }

  Future<void> checkPermission() async {
    PermissionStatus permissionStatus = await Permission.contacts.status;

    if (permissionStatus.isGranted) {
      _permissionGranted = true;
      await _savePermissionState(true);
      await fetchContacts();
    } else {
      await _requestPermission();
    }

    notifyListeners();
  }

  // Request permission to read contacts
  Future<void> _requestPermission() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      _permissionGranted = true;
      await _savePermissionState(true);
      await fetchContacts();
    } else {
      _permissionGranted = false;
      await _savePermissionState(false);
      print("Permission Denied");
    }

    notifyListeners();
  }

  // Fetch contacts if permission is granted
  Future<void> fetchContacts() async {
    _isLoading = true;
    notifyListeners();

    final contacts = await FlutterContacts.getContacts(withProperties: true);

    _contacts = contacts;
    _filteredContacts = contacts; // Initially, no filter is applied
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filteredContacts = _contacts.where((contact) {
      return contact.displayName.toLowerCase().contains(_searchQuery) ||
          contact.phones.any((phone) => phone.number.contains(_searchQuery));
    }).toList();
    notifyListeners();
  }

  void Calling(BuildContext context, String number) async {
    await context.read<PhoneProvider>().addToCallLog(number, 'Outgoing');
    context.read<PhoneProvider>().numberController.clear();
    notifyListeners();
    await context.read<PhoneProvider>().fetchCallLogs();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CallingScreen(phoneno: number)),
    );
  }
}
