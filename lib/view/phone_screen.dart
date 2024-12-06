import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:phone_call_app/controller/phone_provider.dart';
import 'package:phone_call_app/view/widgets/call_log_list.dart';
import 'package:provider/provider.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  late PhoneProvider controller;
  @override
  void initState() {
    super.initState();

    controller = PhoneProvider();
    controller.fetchCallLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhoneProvider>(builder: (context, provider, _) {
      log('logs callinglengthhh:${provider.callLogs.length}');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.callLogs.length,
                itemBuilder: (context, index) {
                  final call = provider.callLogs[index];
                  return CallLogList(
                      contact: call['number'] ?? '',
                      time: call['timestamp'] ?? '',
                      icon: Icons.phone,
                      iconColor: Colors.green);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: TextField(
                      controller: provider.numberController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, letterSpacing: 2),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter phone number',
                      ),
                    ),
                  ),
                  /*  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      String buttonLabel;
                      switch (index) {
                        case 9:
                          buttonLabel = '*';
                          break;
                        case 10:
                          buttonLabel = '0';
                          break;
                        case 11:
                          buttonLabel = '#';
                          break;
                        default:
                          buttonLabel = (index + 1).toString();
                          break;
                      }

                      return ElevatedButton(
                        onPressed: () => provider.appendDigit(buttonLabel),
                        child: Text(
                          buttonLabel,
                          style: TextStyle(fontSize: 24),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                      );
                    },
                  ),*/
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      String text;
                      if (index == 9) {
                        text = '*';
                      } else if (index == 10) {
                        text = '0';
                      } else if (index == 11) {
                        text = '#';
                      } else {
                        text = '${index + 1}';
                      }
                      return InkWell(
                        onTap: () => provider.appendDigit(text),
                        child: Center(
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: provider.deleteLastDigit,
                        child: Icon(Icons.backspace),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.makeCall(context);
                        },
                        child: Icon(Icons.call),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
