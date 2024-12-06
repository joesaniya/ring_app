import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phone_call_app/controller/phone_provider.dart';
import 'package:phone_call_app/view/widgets/call_log_list.dart';
import 'package:provider/provider.dart';

class CallLogScreen extends StatefulWidget {
  @override
  State<CallLogScreen> createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
   late PhoneProvider controller;
  @override
  void initState() {
    super.initState();

    controller = PhoneProvider();
    controller.fetchCallLogs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Call Logs',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
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
      body: Consumer<PhoneProvider>(
        builder: (context, controller, child) {
          log('logs:${controller.callLogs.length}');
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.callLogs.isEmpty) {
            return Center(child: Text('No call logs found.'));
          }

          return ListView.builder(
            itemCount: controller.callLogs.length,
            itemBuilder: (context, index) {
              final call = controller.callLogs[index];
              return CallLogList(
                  contact: call['number'] ?? '',
                  time: call['timestamp'] ?? '',
                  icon: Icons.phone,
                  iconColor: Colors.green);
            },
          );
        },
      ),
    );
  }
}
