// //
// //
// // abandon code an alternative is used instead
// //  Copy Right Warning message
// // copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."
// //

// // // // import 'package:flutter/material.dart';
// // import 'package:flutter_webrtc/flutter_webrtc.dart';
// // import 'package:medical_care_app/signaling.dart';
// //
// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key? key}) : super(key: key);
// //
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   Signaling signaling = Signaling();
// //   RTCVideoRenderer _localRenderer = RTCVideoRenderer();
// //   RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
// //   String? roomId;
// //   TextEditingController textEditingController = TextEditingController(text: '');
// //
// //   @override
// //   void initState() {
// //     _localRenderer.initialize();
// //     _remoteRenderer.initialize();
// //
// //     signaling.onAddRemoteStream = ((stream) {
// //       _remoteRenderer.srcObject = stream;
// //       setState(() {});
// //     });
// //
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _localRenderer.dispose();
// //     _remoteRenderer.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Welcome to Flutter Explained - WebRTC"),
// //       ),
// //       body: Column(
// //         children: [
// //           SizedBox(height: 8),
// //           SingleChildScrollView(
// //             scrollDirection: Axis.horizontal,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     signaling.openUserMedia(_localRenderer, _remoteRenderer);
// //                   },
// //                   child: Text("Open camera & microphone"),
// //                 ),
// //                 SizedBox(
// //                   width: 8,
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () async {
// //                     roomId = await signaling.createRoom(_remoteRenderer);
// //                     textEditingController.text = roomId!;
// //                     setState(() {});
// //                   },
// //                   child: Text("Create room"),
// //                 ),
// //                 SizedBox(
// //                   width: 8,
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Add roomId
// //                     signaling.joinRoom(
// //                       textEditingController.text.trim(),
// //                       _remoteRenderer,
// //                     );
// //                   },
// //                   child: Text("Join room"),
// //                 ),
// //                 SizedBox(
// //                   width: 8,
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     signaling.hangUp(_localRenderer);
// //                   },
// //                   child: Text("Hangup"),
// //                 )
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 8),
// //           Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
// //                   Expanded(child: RTCVideoView(_remoteRenderer)),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text("Join the following Room: "),
// //                 Flexible(
// //                   child: TextFormField(
// //                     controller: textEditingController,
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 8)
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
// class VideoCallPage extends StatefulWidget {
//   @override
//   _VideoCallPageState createState() => _VideoCallPageState();
// }
//
// class _VideoCallPageState extends State<VideoCallPage> {
//   RTCVideoRenderer localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
//   RTCPeerConnection? _peerConnection;
//   final CollectionReference _callCollection =
//   FirebaseFirestore.instance.collection('VideoRooms');
//
//   @override
//   void initState() {
//     super.initState();
//     initWebRTC();
//   }
//
//   Future<void> initWebRTC() async {
//     await localRenderer.initialize();
//     await remoteRenderer.initialize();
//   }
//
//   @override
//   void dispose() {
//     localRenderer.dispose();
//     remoteRenderer.dispose();
//     super.dispose();
//   }
//
//   void _createPeerConnection() async {
//     final configuration = <String, dynamic>{
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ],
//     };
//
//     _peerConnection = await createPeerConnection(configuration, {});
//
//     if (_peerConnection != null) {
//       _peerConnection!.onIceCandidate = (candidate) {
//         // Send the ICE candidate to the other peer
//       };
//
//       _peerConnection!.onAddStream = (stream) {
//         remoteRenderer.srcObject = stream;
//       };
//
//       final mediaConstraints = <String, dynamic>{
//         'audio': true,
//         'video': {
//           'facingMode': 'user',
//         },
//       };
//
//       final localStream =
//       await navigator.mediaDevices.getUserMedia(mediaConstraints);
//
//       localRenderer.srcObject = localStream;
//
//       _peerConnection!.addStream(localStream);
//     }
//   }
//
//   void _startCall() async {
//     _createPeerConnection();
//
//     final callDoc = await _callCollection.add({
//       'status': 'calling',
//       'timestamp': DateTime.now(),
//     });
//
//     final callId = callDoc.id;
//
//     // Listen for call status changes
//     callDoc.snapshots().listen((snapshot) {
//       final data = snapshot.data() as Map;
//       if (data != null && data['status'] == 'accepted') {
//         // Call accepted, start video call
//         // Send signaling message to the other peer to start the call
//       } else if (data != null && data['status'] == 'ended') {
//         // Call ended, clean up resources
//         _endCall();
//       }
//     });
//   }
//
//   void _endCall() async {
//     // Close the peer connection and clean up resources
//     _peerConnection?.close();
//     _peerConnection = null;
//
//     // Update call status to 'ended' in Firestore
//     await _callCollection.doc().update({'status': 'ended'});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('WebRTC Video Call'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Local View',
//               style: TextStyle(fontSize: 18),
//             ),
//             Container(
//               width: 200,
//               height: 200,
//               child: RTCVideoView(localRenderer),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Remote View',
//               style: TextStyle(fontSize: 18),
//             ),
//             Container(
//               width: 200,
//               height: 200,
//               child: RTCVideoView(remoteRenderer),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _startCall,
//               child: Text('Start Call'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _endCall,
//               child: Text('End Call'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
