// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_care_app/views/chat.dart';
import 'package:medical_care_app/widgets/constants.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  String userNumber = '';
  var chatsNumber = 0;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثات'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .orderBy('LastMessageTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            var Roomdata;
            if (snapshot.data != null) {
              for (var doc in snapshot.data!.docs) {
                Roomdata = doc.data() as Map<dynamic, dynamic>;
                if (Roomdata['email1'] == user?.email ||
                    Roomdata['email2'] == user?.email) {
                  chatsNumber++;
                  print(Roomdata);
                  print(userNumber);
                }
              }
            }
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : (chatsNumber == 0)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 23),
                              child: Image.asset('assets/images/no.png',
                                  width: 200),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'لا يوجد اي محادثات بعد!',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 130,
                          child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                userNumber = '';
                                var data = snapshot.data!.docs[index].data()
                                    as Map<dynamic, dynamic>;
                                if (data['email1'] == user?.email) {
                                  userNumber = 'FirstUser';
                                } else if (data['email2'] == user?.email) {
                                  userNumber = 'SecondUser';
                                }
                                if (userNumber != '') {
                                  return ChatsList(data);
                                }

                                return Container();
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 15),
                              itemCount: snapshot.data!.docs.length),
                        ),
                      );
          }),
    );
  }

  Widget ChatsList(data) {
    Map<String, dynamic> Data = data;
    return FocusedMenuHolder(
      openWithTap: false,
      menuWidth: 130,
      duration: Duration(milliseconds: 300),
      blurBackgroundColor: Colors.white38,
      blurSize: 3,
      onPressed: () {},
      menuOffset: 10,
      menuItems: [
        FocusedMenuItem(
          trailingIcon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            'Delete',
          ),
          onPressed: () async {
            final collectionRef =
                FirebaseFirestore.instance.collection('rooms');

            await collectionRef.doc(data['RoomID']).set({'Statue': 'deleted'});
          },
        )
      ],
      child: GestureDetector(
        onTap: () {
          Data.addAll({'userNumber': userNumber});
          print(data);
          Get.to(() => Chat(roomData: data));
          userNumber = '';
          setState(() {});
        },
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                height: 70,
                child: ListTile(
                  title: (userNumber == 'FirstUser')
                      ? Text(data['name2'])
                      : Text(data['name1']),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white38,
                    radius: 45,
                    backgroundImage: (userNumber == 'FirstUser')
                        ? (data['image2'] == null)
                            ? AssetImage('assets/images/doctor (10).png')
                            : NetworkImage(
                                data['image2'],
                              ) as ImageProvider<Object>?
                        : (data['image1'] == null)
                            ? AssetImage('assets/images/doctor (10).png')
                            : NetworkImage(data['image1'])
                                as ImageProvider<Object>?,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width - 230,
                            child: Text(
                              data['lastMessage'],
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(formatTimestamp(data['LastMessageTime']))
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade300,
                thickness: 1,
                indent: 9,
                endIndent: 9,
              ),
            ],
          ),
        ),
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
      final timeFormat = DateFormat('hh:mm a');
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

  Future<void> chatsNumberCount(QuerySnapshot? snapshot) async {
    var data;
    if (snapshot != null) {
      for (var doc in snapshot.docs) {
        data = await doc.data() as Map<dynamic, dynamic>;
        if (data['email1'] == user?.email || data['email2'] == user?.email) {
          chatsNumber++;
        }
      }
    }
    print(data);
    print(chatsNumber);
    print('------------------------');
  }
}
