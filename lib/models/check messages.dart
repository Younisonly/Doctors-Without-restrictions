import 'dart:io';
import 'package:get/get.dart';
// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

class check extends GetxController {
  Map Exist = {};
var progress=0.1;
String current='';
  var isdownloading = false;
  String messageContents = '';

  MessageValue(value) {
    messageContents = value;
    update();
  }

  doesFileExist(String folderPath, String fileName)  async {
    File file =  File('$folderPath/$fileName');
    bool result =  file.existsSync();
    Exist[fileName] = result;

  }

  StillDowanloading (value){
    isdownloading = value;
     update();

  }

  progressIndecating(value,fileName){
    progress=value;
    current=fileName;

  }
}
