// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
//
// final FirebaseAuth _auth = FirebaseAuth.instance;
// final User? user = _auth.currentUser;
//
// class VideoCall extends StatefulWidget {
//   var roomData;
//   VideoCall({required this.roomData});
//
//
//   @override
//   State<VideoCall> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<VideoCall>
// {
//   bool audioMuted = true;
//   bool videoMuted = true;
//   bool screenShareOn = false;
//   List<String> participants = [];
//   final _jitsiMeetPlugin = JitsiMeet();
//
//   join() async {
//
// print(widget.roomData);
// String RoomID = widget.roomData['RoomID'] + widget.roomData['email1'] + widget.roomData['email2'];
// print(Icons.room_outlined);
// print('000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
//     var options = JitsiMeetConferenceOptions(
//       serverURL:'https://meet.jit.si/$RoomID' ,
//       room: "$RoomID",
//       configOverrides: {
//         "startWithAudioMuted": false,
//         "startWithVideoMuted": false,
//         "subject": "chat"
//       },
//       featureFlags: {
//         "unsaferoomwarning.enabled": false,
//         // "ios.screensharing.enabled": true
//       },
//       userInfo: JitsiMeetUserInfo(
//           displayName: (widget.roomData['email1']==user?.email)?widget.roomData['name1']:widget.roomData['name2'],
//           email: (widget.roomData['email1']==user?.email)?widget.roomData['email1']:widget.roomData['email2'],
//           avatar:(widget.roomData['email1']==user?.email)?widget.roomData['image1']:widget.roomData['image2']),
//     );
//
//     var listener = JitsiMeetEventListener(
//       conferenceJoined: (url) {
//         debugPrint("conferenceJoined: url: $url");
//       },
//       conferenceTerminated: (url, error) {
//         debugPrint("conferenceTerminated: url: $url, error: $error");
//       },
//       conferenceWillJoin: (url) {
//         debugPrint("conferenceWillJoin: url: $url");
//       },
//       participantJoined: (email, name, role, participantId) {
//         print('00000000000000000000');
//         debugPrint(
//           "participantJoined: email: $email, name: $name, role: moderator, "
//               "participantId: $participantId",
//         );
//         participants.add(participantId!);
//       },
//       participantLeft: (participantId) {
//         debugPrint("participantLeft: participantId: $participantId");
//       },
//       audioMutedChanged: (muted) {
//         debugPrint("audioMutedChanged: isMuted: $muted");
//       },
//       videoMutedChanged: (muted) {
//         debugPrint("videoMutedChanged: isMuted: $muted");
//       },
//       endpointTextMessageReceived: (senderId, message) {
//         debugPrint(
//             "endpointTextMessageReceived: senderId: $senderId, message: $message");
//       },
//       screenShareToggled: (participantId, sharing) {
//         debugPrint(
//           "screenShareToggled: participantId: $participantId, "
//               "isSharing: $sharing",
//         );
//       },
//       chatMessageReceived: (senderId, message, isPrivate, timestamp) {
//         debugPrint(
//           "chatMessageReceived: senderId: $senderId, message: $message, "
//               "isPrivate: $isPrivate, timestamp: $timestamp",
//         );
//       },
//       chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
//       participantsInfoRetrieved: (participantsInfo) {
//         debugPrint(
//             "participantsInfoRetrieved: participantsInfo: $participantsInfo, ");
//       },
//       readyToClose: () {
//         debugPrint("readyToClose");
//       },
//     );
//     Get.to( await _jitsiMeetPlugin.join(options, listener));
//
//   }
//
//   hangUp() async {
//     await _jitsiMeetPlugin.hangUp();
//   }
//
//   setAudioMuted(bool? muted) async {
//     var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
//     debugPrint("$a");
//     setState(() {
//       audioMuted = muted;
//     });
//   }
//
//   setVideoMuted(bool? muted) async {
//     var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
//     debugPrint("$a");
//     setState(() {
//       videoMuted = muted;
//     });
//   }
//
//   sendEndpointTextMessage() async {
//     var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: "HEY");
//     debugPrint("$a");
//
//     for (var p in participants) {
//       var b =
//       await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: "HEY");
//       debugPrint("$b");
//     }
//   }
//
//   toggleScreenShare(bool? enabled) async {
//     await _jitsiMeetPlugin.toggleScreenShare(enabled!);
//
//     setState(() {
//       screenShareOn = enabled;
//     });
//   }
//
//   openChat() async {
//     await _jitsiMeetPlugin.openChat();
//   }
//
//   sendChatMessage() async {
//     var a = await _jitsiMeetPlugin.sendChatMessage(message: "HEY1");
//     debugPrint("$a");
//
//     for (var p in participants) {
//       a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: "HEY2");
//       debugPrint("$a");
//     }
//   }
//
//   closeChat() async {
//     await _jitsiMeetPlugin.closeChat();
//   }
//
//   retrieveParticipantsInfo() async {
//     var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
//     debugPrint("$a");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: Center(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: join,
//                     child: const Text("Join"),
//                   ),
//                   TextButton(onPressed: hangUp, child: const Text("Hang Up")),
//                   Row(children: [
//                     const Text("Set Audio Muted"),
//                     Checkbox(
//                       value: audioMuted,
//                       onChanged: setAudioMuted,
//                     ),
//                   ]),
//                   Row(children: [
//                     const Text("Set Video Muted"),
//                     Checkbox(
//                       value: videoMuted,
//                       onChanged: setVideoMuted,
//                     ),
//                   ]),
//                   TextButton(
//                       onPressed: sendEndpointTextMessage,
//                       child: const Text("Send Hey Endpoint Message To All")),
//                   Row(children: [
//                     const Text("Toggle Screen Share"),
//                     Checkbox(
//                       value: screenShareOn,
//                       onChanged: toggleScreenShare,
//                     ),
//                   ]),
//                   TextButton(
//                       onPressed: openChat, child: const Text("Open Chat")),
//                   TextButton(
//                       onPressed: sendChatMessage,
//                       child: const Text("Send Chat Message to All")),
//                   TextButton(
//                       onPressed: closeChat, child: const Text("Close Chat")),
//                   TextButton(
//                       onPressed: retrieveParticipantsInfo,
//                       child: const Text("Retrieve Participants Info")),
//                 ]),
//           ))
//     ;
//   }
// }

// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

//////////////////////////////////
///// Use of zego Free trail /////
//////////////////////////////////

class videoCallInvetation extends StatefulWidget {
   videoCallInvetation({required this.RoomData});

var RoomData;

  @override
  State<videoCallInvetation> createState() => _videoCallInvetationState();
}

class _videoCallInvetationState extends State<videoCallInvetation> {
  void initState() {
    super.initState();
    invetation();
  }
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return  ZegoUIKitPrebuiltCall(
      appID: 1109622907, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: '55a2dc4241f7b4b5a79c0671f1d0b980cf38f4aee2feee45791e410f3d8393c8', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: user?.uid as String,
      userName: user?.email as String,
      callID: widget.RoomData['RoomID'],
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }

  invetation() async {
    var userToJoin;
    var userInfo;
    if (widget.RoomData['userNumber'] == 'FirstUser') {
      userToJoin= widget.RoomData['email2'];
    } else {
      userToJoin = widget.RoomData['email1'];
    }
    QuerySnapshot userDetails=await FirebaseFirestore.instance.collection('Users').where('email',isEqualTo:userToJoin ).get();

    if (userDetails.docs.isNotEmpty) {
      userInfo =  userDetails.docs[0].data() as Map<String, dynamic>;
    }
    ZegoSendCallInvitationButton(
      isVideoCall: true,
      resourceID: "zegouikit_call",    // For offline call notification
      invitees: [
        ZegoUIKitUser(
          id: userInfo['userId'],
          name: userInfo['email'],
        ),
      ],
    );
  }
}

