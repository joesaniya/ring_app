import 'dart:async';
import 'dart:ffi';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "45c3e33f16e441ea896ae541dcfceadb";
const token =
    "007eJxTYJjPUHfLeMqvf/yNb6MPxV1gSl2qmyX3Wi06znHq9tOvf2QoMJiYJhunGhunGZqlmpgYpiZaWJolppqaGKYkpyWnJqYkaV4PTG8IZGRoXajFyMgAgSA+C0NIanEJAwMAqcIgwA==";
const channel = "Test";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isVideoEnabled = true;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

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

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Toggle video on/off
  Future<void> _toggleVideo() async {
    if (_isVideoEnabled) {
      await _engine.disableVideo();
    } else {
      await _engine.enableVideo();
    }
    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
    });
  }

  // End the call
  Future<void> _endCall() async {
    await _dispose();
    Navigator.pop(context); // Optional: navigate back after ending the call
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          _remoteVideo(),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Video Toggle Button
          FloatingActionButton(
            onPressed: _toggleVideo,
            child: Icon(
              _isVideoEnabled ? Icons.videocam_off : Icons.videocam,
            ),
            heroTag: 'video-toggle',
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 10),
          // End Call Button
          FloatingActionButton(
            onPressed: _endCall,
            child: const Icon(Icons.call_end),
            heroTag: 'end-call',
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Please wait for remote user to join',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
