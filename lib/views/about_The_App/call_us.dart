// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:flutter/material.dart';
import '../../widgets/constants.dart';

class callUs extends StatelessWidget {
  const callUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:Text('اتصل بنا'),
      ),
      body:  Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width-30,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                const BoxShadow(
                    blurRadius: 5, offset: Offset(0, 2), color: Colors.grey)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/earth.png',height: 20,width: 20,),
                Text('www.Doctors_Without_Restrictions.com'),
                Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey,),

              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width-30,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                const BoxShadow(
                    blurRadius: 5, offset: Offset(0, 2), color: Colors.grey)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/facebook.png',height: 20,width: 20,),
                Text('Doctors_Without_Restrictions.facebook.com'),
                Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey,),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width-30,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                const BoxShadow(
                    blurRadius: 5, offset: Offset(0, 2), color: Colors.grey)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/twitter.png',height: 20,width: 20,),
                Text('Doctors_Without_Restrictions'),
                Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey,),

              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width-30,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                const BoxShadow(
                    blurRadius: 5, offset: Offset(0, 2), color: Colors.grey)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/gmail.png',height: 20,width: 20,),
                Text('Doctors_Without_Restrictions@gmail.com'),
                Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey,),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width-30,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                const BoxShadow(
                    blurRadius: 5, offset: Offset(0, 2), color: Colors.grey)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.call,color: primaryColor,),
                Text('775400548 - 101036058'),
                Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey,),
              ],
            ),
          ),



        ],
      ),
    );

  }
}
