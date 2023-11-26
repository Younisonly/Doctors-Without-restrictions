// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_care_app/widgets/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../models/check messages.dart';
import 'dart:ui';

import 'VideoCall.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class Chat extends StatefulWidget {
  var roomData;

  Chat({required this.roomData});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  File? selectedFile;
  String downloadUrl = '';
  String fileName = '';
  String fileSize = '';
  String fileType = '';
  String filePathForSender = '';
  String FileNameForCallBack = '';
  String typeForCallBack = '';
  var lastMessage;
  List photoList = [
    'jpeg',
    'jpg',
    'gif',
    'bmp',
    'tiff',
    'tif',
    'raw',
    'heic',
    'heif',
    'webp',
    'svg',
    'psd'
  ];
  var controller = Get.put(check());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white38,
                radius: 22,
                backgroundImage: (widget.roomData['userNumber'] == 'FirstUser')
                    ? (widget.roomData['image2'] == null)
                        ? AssetImage('assets/images/doctor (10).png')
                        : NetworkImage(widget.roomData['image2'])
                            as ImageProvider<Object>?
                    : (widget.roomData['image1'] == null)
                        ? AssetImage('assets/images/doctor (10).png')
                        : NetworkImage(widget.roomData['image1'])
                            as ImageProvider<Object>?,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                (widget.roomData['userNumber'] == 'FirstUser')
                    ? widget.roomData['name2']
                    : widget.roomData['name2'],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {

              Get.to(videoCallInvetation(RoomData: widget.roomData));

            },
            icon: Icon(Icons.videocam_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .where('RoomID', isEqualTo: widget.roomData['RoomID'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final roomDocuments = snapshot.data!.docs;
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: roomDocuments.length,
                    itemBuilder: (context, index) {
                      final roomDocument = roomDocuments[index];
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(roomDocument.id)
                            .collection('Chat')
                            .orderBy('sendAt')
                            .snapshots(),
                        builder: (context, subCollectionSnapshot) {
                          if (subCollectionSnapshot.connectionState ==
                              ConnectionState.active) {
                            // Check if new messages have arrived
                            // if (subCollectionSnapshot
                            //     .data!.docChanges.isNotEmpty) {
                            //   GetToBottom();
                            // }
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  subCollectionSnapshot.data!.docs.length,
                              itemBuilder: (context, subIndex) {

                                final subCollectionDocument =
                                    subCollectionSnapshot.data!.docs[subIndex]
                                        .data() as Map<dynamic, dynamic>;
                                if (subCollectionDocument['type'] != 'text') {
                                  if (subCollectionDocument['senderEmail'] ==
                                      user?.email) {
                                    List<String> parts = subCollectionDocument[
                                            'filePathForSender']
                                        .split('/');
                                    parts.removeLast();

                                    String finalPath = parts.join('/');
                                    controller.doesFileExist(
                                        finalPath,
                                        subCollectionDocument['name']
                                            .replaceAll(
                                                subCollectionDocument['ID'],
                                                ''));
                                  } else if (subCollectionDocument[
                                          'senderEmail'] !=
                                      user?.email) {
                                    controller.doesFileExist(
                                        '/storage/emulated/0/Download/MedicalCare/',
                                        subCollectionDocument['name'] +
                                            '.' +
                                            subCollectionDocument['type']);
                                  }
                                  print(controller.Exist);
                                }
if(subCollectionDocument['status']!='deleted'){
                                return FocusedMenuHolder(
openWithTap: false,menuWidth: 130,
                                  duration: Duration(milliseconds: 300),
                                  blurBackgroundColor: Colors.black54,
                                  onPressed: (){},
                                  menuOffset: 10,

                                  menuItems: [
                                    FocusedMenuItem
                                      (
                                      trailingIcon: Icon(Icons.delete,color: Colors.red,),

                                      title: Text('Delete',),
                                        onPressed: () async {
                                          final collectionRef = FirebaseFirestore.instance.collection('rooms');
                                          final documentRef = collectionRef.doc(widget.roomData['RoomID']).collection('Chat');

                                          await documentRef.doc(subCollectionDocument['ID']).set({
                                            'statue':'deleted'
                                          });
                                        },
                                    )
                                  ],
                                  child: Align(
                                    alignment:
                                        (subCollectionDocument['senderEmail'] ==
                                                user?.email)
                                            ? Alignment.bottomRight
                                            : Alignment.bottomLeft,
                                    child: Container(
                                        constraints: BoxConstraints(
                                          minWidth: 100,
                                          maxWidth:
                                              MediaQuery.of(context).size.width -
                                                  90,
                                        ),
                                        margin: EdgeInsets.only(
                                            right: 15,
                                            left: 15,
                                            top: 7,
                                            bottom: 7),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: (subCollectionDocument[
                                                        'senderEmail'] ==
                                                    user?.email)
                                                ? [Colors.white, Colors.white]
                                                : [primaryColor, primaryColor],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 7,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: (subCollectionDocument[
                                                        'senderEmail'] ==
                                                    user?.email)
                                                ? Radius.circular(0)
                                                : Radius.circular(20),
                                            bottomLeft: (subCollectionDocument[
                                                        'senderEmail'] ==
                                                    user?.email)
                                                ? Radius.circular(20)
                                                : Radius.circular(0),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (subCollectionDocument['type'] ==
                                                'text')
                                              Text(
                                                subCollectionDocument['content'],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: (subCollectionDocument[
                                                                'senderEmail'] ==
                                                            user?.email)
                                                        ? Colors.black
                                                        : Colors.white),
                                              )
                                            else if (photoList.contains(
                                                subCollectionDocument['type']))
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Scaffold(
                                                            appBar: AppBar(
                                                              backgroundColor:
                                                                  primaryColor,
                                                              title: Text(
                                                                subCollectionDocument[
                                                                    'name'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            body: Container(
                                                              child: PhotoView(
                                                                imageProvider:
                                                                    NetworkImage(
                                                                  subCollectionDocument[
                                                                      'content'],
                                                                ),
                                                                minScale:
                                                                    PhotoViewComputedScale
                                                                            .contained *
                                                                        0.8,
                                                                maxScale:
                                                                    PhotoViewComputedScale
                                                                            .covered *
                                                                        2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        subCollectionDocument[
                                                            'content'],
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                      return Center(
                                                        child: Icon(
                                                          Icons.error,
                                                          size: 80,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                180,
                                                            child: Text(
                                                              subCollectionDocument[
                                                                      'name']
                                                                  .replaceFirst(
                                                                      subCollectionDocument[
                                                                          'ID'],
                                                                      ''),
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: (subCollectionDocument[
                                                                              'senderEmail'] ==
                                                                          user
                                                                              ?.email)
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '${subCollectionDocument['type']}'
                                                            ' - ${subCollectionDocument['size']}',
                                                            style: TextStyle(
                                                                color: (subCollectionDocument[
                                                                            'senderEmail'] ==
                                                                        user
                                                                            ?.email)
                                                                    ? Colors.grey
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                      (controller.Exist[subCollectionDocument[
                                                                          'name'] +
                                                                      '.' +
                                                                      subCollectionDocument[
                                                                          'type']] ==
                                                                  true ||
                                                              controller
                                                                      .Exist[subCollectionDocument[
                                                                          'name']
                                                                      .replaceAll(
                                                                          subCollectionDocument[
                                                                              'ID'],
                                                                          '')] ==
                                                                  true)
                                                          ? IconButton(
                                                              onPressed: () {
                                                                (subCollectionDocument['senderEmail'] ==
                                                                        user
                                                                            ?.email)
                                                                    ? openLocalFile(
                                                                        subCollectionDocument[
                                                                            'filePathForSender'])
                                                                    : openFile('/storage/emulated/0/Download/MedicalCare/' +
                                                                        subCollectionDocument[
                                                                            'name'] +
                                                                        '.' +
                                                                        subCollectionDocument[
                                                                            'type']);
                                                              },
                                                              icon: Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  color: (subCollectionDocument[
                                                                              'senderEmail'] ==
                                                                          user
                                                                              ?.email)
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .greenAccent,
                                                                  size: 25),
                                                            )
                                                          : TextButton(
                                                              onPressed: () {
                                                                controller
                                                                    .StillDowanloading(
                                                                        true);
                                                                downloadFile(
                                                                    subCollectionDocument[
                                                                        'content'],
                                                                    subCollectionDocument[
                                                                        'name'],
                                                                    subCollectionDocument[
                                                                        'type']);
                                                              },
                                                              child: (controller
                                                                              .isdownloading ==
                                                                          true &&
                                                                      controller
                                                                              .current ==
                                                                          subCollectionDocument[
                                                                              'name'])
                                                                  ? CircularProgressIndicator(
                                                                      color:
                                                                          primaryColor)
                                                                  : Icon(
                                                                      Icons
                                                                          .download,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 25),
                                                            )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            else
                                              Row(
                                                children: [
                                                  Opacity(
                                                    opacity: 0.7,
                                                    child: Icon(
                                                      Icons.insert_drive_file,
                                                      color:
                                                          (subCollectionDocument[
                                                                      'type'] ==
                                                                  'pdf')
                                                              ? Colors.red
                                                              : Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                240,
                                                        child: Text(
                                                          subCollectionDocument[
                                                                  'name']
                                                              .replaceFirst(
                                                                  subCollectionDocument[
                                                                      'ID'],
                                                                  ''),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: (subCollectionDocument[
                                                                          'senderEmail'] ==
                                                                      user?.email)
                                                                  ? Colors.black
                                                                  : Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${subCollectionDocument['type']}'
                                                        ' - ${subCollectionDocument['size']}',
                                                        style: TextStyle(
                                                            color: (subCollectionDocument[
                                                                        'senderEmail'] ==
                                                                    user?.email)
                                                                ? Colors.grey
                                                                : Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ((controller.Exist[subCollectionDocument[
                                                                      'name'] +
                                                                  '.' +
                                                                  subCollectionDocument[
                                                                      'type']] ==
                                                              true) ||
                                                          controller.Exist[
                                                                  subCollectionDocument[
                                                                          'name']
                                                                      .replaceAll(
                                                                          subCollectionDocument[
                                                                              'ID'],
                                                                          '')] ==
                                                              true)
                                                      ? IconButton(
                                                          onPressed: () {
                                                            (subCollectionDocument[
                                                                        'senderEmail'] ==
                                                                    user?.email)
                                                                ? openLocalFile(
                                                                    subCollectionDocument[
                                                                        'filePathForSender'])
                                                                : openFile('/storage/emulated/0/Download/MedicalCare/' +
                                                                    subCollectionDocument[
                                                                        'name'] +
                                                                    '.' +
                                                                    subCollectionDocument[
                                                                        'type']);
                                                          },
                                                          icon: Icon(
                                                              Icons.play_arrow,
                                                              color: Colors.green,
                                                              size: 25),
                                                        )
                                                      : TextButton(
                                                          onPressed: () {
                                                            controller
                                                                .StillDowanloading(
                                                                    true);
                                                            downloadFile(
                                                                subCollectionDocument[
                                                                    'content'],
                                                                subCollectionDocument[
                                                                    'name'],
                                                                subCollectionDocument[
                                                                    'type']);
                                                          },
                                                          child: (controller
                                                                          .isdownloading ==
                                                                      true &&
                                                                  controller
                                                                          .current ==
                                                                      subCollectionDocument[
                                                                          'name'])
                                                              ? CircularProgressIndicator(
                                                                  color:
                                                                      primaryColor)
                                                              : Icon(
                                                                  Icons.download,
                                                                  color:
                                                                      Colors.grey,
                                                                  size: 25),
                                                        )
                                                ],
                                              ),
                                            SizedBox(
                                              width: 120,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    formatTimestamp(
                                                            subCollectionDocument[
                                                                'sendAt'])
                                                        .trim(),
                                                    style: TextStyle(
                                                      color: (subCollectionDocument[
                                                                  'senderEmail'] ==
                                                              user?.email)
                                                          ? Colors.grey
                                                          : Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                );}
return Container();
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          GetBuilder<check>(
            builder: (controller) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          controller.MessageValue(value);
                        },
                        controller: _messageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          ),
                          hintText: 'اكتب رسالة',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      if (controller.messageContents.trim() != '') {
                        controller.MessageValue('');
                        fileType = 'text';
                        SendMessage();
                      } else {
                        selectFile();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: FaIcon(
                        (controller.messageContents == '')
                            ? FontAwesomeIcons.paperclip
                            : Icons.send_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Timestamp is today, return time
      final timeFormat = DateFormat('hh:mm a', 'ar');
      return timeFormat.format(dateTime);
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      // Timestamp is yesterday, return "yesterday"
      return 'الأمس';
    } else {
      // Timestamp is not today or yesterday, return date in Arabic format
      final dateFormat = DateFormat('dd MMMM yyyy', 'ar');
      return dateFormat.format(dateTime);
    }
  }

  SendMessage() async {
    CollectionReference parentCollectionRef =
        FirebaseFirestore.instance.collection('rooms');

    QuerySnapshot parentQuerySnapshot = await parentCollectionRef
        .where('RoomID', isEqualTo: widget.roomData['RoomID'])
        .get();
    if (parentQuerySnapshot.docs.isNotEmpty) {
      DocumentReference parentDocumentRef =
          parentQuerySnapshot.docs[0].reference;

      CollectionReference subCollectionRef =
          parentDocumentRef.collection('Chat');

      DocumentReference newSubDocumentRef = subCollectionRef
          .doc(); // Create a new document reference with a generated ID
      String newSubDocumentId = newSubDocumentRef.id;
      Map<String, dynamic> data = {};
      if (fileType == 'text') {
        lastMessage = _messageController.text;

        data = {
          'senderEmail': user?.email,
          'sendAt': Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
          'ID': newSubDocumentId,
          'content': _messageController.text,
          'type': 'text',
          'status': 'sent',
          'messageNO': widget.roomData['messagesNO'] + 1,
        };
      } else {
        lastMessage = 'Media File';

        data = {
          'senderEmail': user?.email,
          'sendAt': Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
          'ID': newSubDocumentId,
          'content': downloadUrl,
          'type': fileType,
          'status': 'sent',
          'size': fileSize,
          'filePathForSender': filePathForSender,
          'name': fileName! + newSubDocumentId,
          'messageNO': widget.roomData['messagesNO'] + 1,
        };
      }

      parentDocumentRef.update({
        'messagesNO': widget.roomData['messagesNO'] + 1,
        'lastMessage': lastMessage,
        'LastMessageTime':Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),

      });
      newSubDocumentRef.set(data);
      _messageController.text = '';
    }
  }

  // GetToBottom() {
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 1000),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      selectedFile = File(result.files.single.path!);
      filePathForSender = result.files.single.path!;
      fileName = result.files.single.name;
      int size = await selectedFile!.length();
      fileSize = getFileSize(size);
      fileType = result.files.single.extension!;
      await uploadFile();
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) return;

    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(widget.roomData['RoomID'])
          .child(fileName);

      await ref.putFile(selectedFile!);
      downloadUrl = await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
    }

    SendMessage();
  }

  String getFileSize(int bytes) {
    const int KB = 1024;
    const int MB = KB * 1024;
    const int GB = MB * 1024;

    if (bytes >= GB) {
      return '${(bytes / GB).toStringAsFixed(2)} GB';
    } else if (bytes >= MB) {
      return '${(bytes / MB).toStringAsFixed(2)} MB';
    } else if (bytes >= KB) {
      return '${(bytes / KB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }

  openFile(String filePath) async {
    print('open file-0000000000000000000000');

    File file = File(filePath);
    print(file);
    OpenResult result = await OpenFile.open(file.path);

    if (result.type != ResultType.done) {
      Get.snackbar(
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        'لايمكن فتح الملف',
        'حصل خطا او ربما لا يوجد اي برنامج لفتح هذ النوع من الملفات!',
        colorText: Colors.white,
        backgroundColor: primaryColor,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error opening file: ${result.message}');
    }
  }

  void downloadFile(String downloadUrl, String fileName, String type) async {
    await Permission.storage.request();

    Directory folder = Directory('/storage/emulated/0/Download/MedicalCare');
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }
    String filePath =
        '/storage/emulated/0/Download/MedicalCare/$fileName.$type';

    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: '/storage/emulated/0/Download/MedicalCare',
      fileName: fileName + '.' + type!,
      showNotification: true,
      openFileFromNotification: true,
    );

    FileNameForCallBack = fileName;
    typeForCallBack = type;

    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDownloadTasks();
    });
    print('File downloaded and saved to: $filePath');
  }

  void fetchDownloadTasks() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();

    for (DownloadTask task in tasks!) {
      if (task.status == DownloadTaskStatus.running) {
        int progress = task.progress;
        controller.progressIndecating(progress / 100, FileNameForCallBack);
        controller.StillDowanloading(true);
        print('it is in');
      } else if (task.status == DownloadTaskStatus.complete) {
        controller.doesFileExist('/storage/emulated/0/Download/MedicalCare/',
            FileNameForCallBack + '.' + typeForCallBack);
        controller.StillDowanloading(false);
        controller.current == '';

        // Do something with the completed task
      }
    }
  }

  openLocalFile(filePathForSender) {
    print('openLocal file-0000000000000000000000');
    print(user?.email);

    openFile(filePathForSender);
  }
}
