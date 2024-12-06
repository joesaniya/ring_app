import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phone_call_app/controller/provier-common.dart';
import 'package:phone_call_app/modal/notification_serviice.dart';
import 'package:phone_call_app/view/bottom_screen.dart';
import 'package:provider/provider.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  runApp(const MyApp());
}
*/

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: ProviderHelperClass.instance.providerLists,
        // child: ,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
              fontFamily: "Montserrat",
              useMaterial3: false,
            ),
            home: const BottomScreen(),
          );
        });
  }
}

/*import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_call_app/view/agora_sample.dart';

void main() => runApp(const MaterialApp(home: Samp()));


class Samp extends StatelessWidget {
  const Samp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      title: 'Voice Calling App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CallPage(),
    );
  }
}

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late RtcEngine _engine;
  bool isMuted = false;
  bool isCalling = false;
  String phoneNumber = '';
  int? _remoteUid;
  int? _localUid;
  bool _localUserJoined = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    initializeAgora();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.camera.request(); // Uncomment if using video calls
  }

  Future<void> initializeAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine.enableAudio();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
  }

  void startCall() async {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        isCalling = true;
      });
      // Join the channel (phoneNumber here is used as the channel name)
      await _engine.joinChannel(
          token: token,
          channelId: phoneNumber,
          uid: 0,
          options: const ChannelMediaOptions());
    }
  }

  void endCall() {
    setState(() {
      isCalling = false;
    });
    _engine.leaveChannel();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    if (isMuted) {
      _engine.muteLocalAudioStream(true);
    } else {
      _engine.muteLocalAudioStream(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Call')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter Phone Number'),
              onChanged: (value) => phoneNumber = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startCall,
              child: Text(isCalling ? 'In Call' : 'Start Call'),
            ),
            if (isCalling)
              IconButton(
                icon: Icon(Icons.call_end),
                onPressed: endCall,
                color: Colors.red,
              ),
            if (isCalling)
              IconButton(
                icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
                onPressed: toggleMute,
                color: isMuted ? Colors.red : Colors.green,
              ),
            if (_remoteUid != null) Text('Remote User UID: $_remoteUid'),
            if (_localUid != null) Text('Local User UID: $_localUid'),
          ],
        ),
      ),
    );
  }
}
*/