import 'package:phone_call_app/controller/bottom_controller.dart';
import 'package:phone_call_app/controller/contacts_provider.dart';
import 'package:phone_call_app/controller/phone_provider.dart';

import 'calling-provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderHelperClass {
  static ProviderHelperClass? _instance;

  static ProviderHelperClass get instance {
    _instance ??= ProviderHelperClass();
    return _instance!;
  }

  List<SingleChildWidget> providerLists = [
   
    ChangeNotifierProvider(create: (context) => BottomProvider()),
    ChangeNotifierProvider(create: (context) => PhoneProvider()),
    ChangeNotifierProvider(create: (context) => CallingProvider()),
    ChangeNotifierProvider(create: (context) => ContactProvider()),
  ];
}
