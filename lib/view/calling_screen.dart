import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../controller/calling-provider.dart';
import '../main.dart';

class CallingScreen extends StatefulWidget {
  final String phoneno;
  CallingScreen({required this.phoneno});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen>
    with WidgetsBindingObserver {
  late CallingProvider controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = CallingProvider();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> showCallNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'call_channel_id',
      'Call Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      icon: '@mipmap/ic_launcher',
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Active Call',
      'You are in a call with Unknown',
      notificationDetails,
    );
  }

  Future<void> removeCallNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      showCallNotification();
    } else if (state == AppLifecycleState.resumed) {
      removeCallNotification();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CallingProvider>(
      create: (_) => controller,
      child: Consumer<CallingProvider>(builder: (context, provider, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.brown],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 50),
              child: Column(
                children: [
                  Text(
                    'Calling....',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text(
                      'UnKnown',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      '+91 ${widget.phoneno}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      radius: 70,
                      child: ClipOval(
                        child: Image.network(
                          'https://w0.peakpx.com/wallpaper/646/420/HD-wallpaper-shin-chan-in-red-dress-on-green-grass-shin-chan.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.add, color: Colors.grey, size: 40),
                            Text('Add call',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.video_call,
                                color: Colors.grey, size: 40),
                            Text('Video call',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.bluetooth,
                                color: Colors.white, size: 40),
                            Text('Bluetooth',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.volume_up,
                                color: Colors.green, size: 40),
                            Text('Speaker',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.mic_off, color: Colors.grey, size: 40),
                            Text('Mute', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.dialpad, color: Colors.white, size: 40),
                            Text('Dialpad',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      provider.goback(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.phone, color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
