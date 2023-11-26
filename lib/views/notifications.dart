// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_care_app/views/viewNotification.dart';
import 'package:medical_care_app/widgets/constants.dart';

class Notifications extends StatefulWidget {

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    var notificationsNumber=0;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الإشعارات'),
        backgroundColor: primaryColor,

      ),
      body:
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Notifications')
              // .where('owner',isEqualTo:user?.email)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              for (var doc in snapshot.data!.docs) {


                  notificationsNumber++;
              }
            }

            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : (notificationsNumber == 0)
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Image.asset('assets/images/notification.png',
                        width: 180),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'لا توجد اي إشعارات بعد!',
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
                      var data = snapshot.data!.docs[index].data()
                      as Map<dynamic, dynamic>;
                      print(data);
                      print('data:');
                      print(user?.email);
                      if(data['owner']==user?.email) {
                                  return NotsList(data);
                                }
                      else {return Container();}
                              },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                    itemCount: snapshot.data!.docs.length),
              ),
            );
          }),
    );
  }
 Widget NotsList(data){
    return GestureDetector(
      onTap: (){
        Get.to(ViewNotification(data: data));
FirebaseFirestore.instance.collection('Notifications').doc(data['id']).update(
    {
      'status':'read'
    });
setState(() {

});
      },
      child: Container(
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

        child:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(data['Title'],style:TextStyle(fontSize: 16)),
              Icon(Icons.circle,color: (data['status']=='read')?Colors.transparent:Colors.green,size: 17,)
            ],),
          SizedBox(height: 10,),
          Text(data['Message'],maxLines: 2,
            overflow: TextOverflow.ellipsis,),
            SizedBox(height: 15,),
            Text(formatTimestamp(data['date']),style: TextStyle(color: Colors.grey,fontSize: 14),),
        ],) ,
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

}
