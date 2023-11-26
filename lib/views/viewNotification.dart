// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_care_app/widgets/constants.dart';

class ViewNotification extends StatefulWidget {
   ViewNotification({required this.data});
var data;
  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20,right: 20,left: 20,bottom: 7),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                const BoxShadow(
                    blurRadius: 5, offset: Offset(0, 2), color: Colors.grey)
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data['Title'],style:TextStyle(fontSize: 16)),
                SizedBox(height: 10,),
                Text(widget.data['Message']),
SizedBox(height: 15,),
                Text(formatTimestamp(widget.data['date']),style: TextStyle(color: Colors.grey,fontSize: 14),)
              ],) ,
          ),
        ],
      ),
    );
  }
}
String formatTimestamp(Timestamp timestamp) {
  final now = DateTime.now();
  final dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    // Timestamp is today, return time
    final timeFormat = DateFormat('hh:mm a','ar');
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
