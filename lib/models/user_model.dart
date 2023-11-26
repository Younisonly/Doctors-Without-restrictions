// يعرف النموذج UserModel الذي يحتوي على خصائص المستخدم
// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

class UserModel {
  // خصائص المستخدم
  late var userId, email, name, type, Image ;

  // البناء الأساسي
  UserModel({this.userId, this.email, this.name,this.type,this.Image});

  // دله لتحويل البيانات من خرائط Map إلى نموذج UserModel
  UserModel.fromJson(Map<dynamic, dynamic> map) {
    // التأكد من صحة الخريطة
    if (map == null) {
      return;
    }
    // جلب الخصائص من الخريطة وتخزينها في المتغيرات المناسبة
    userId = map['userId'];
    email = map['email'];
    name = map['name'];
    Image=map['Image'];
  }

  // دله لتحويل البيانات من نموذج UserModel إلى خرائط Map
  toJson() {
    return {
      'type': type,
      'userId': userId,
      'email': email,
      'name': name,
      'Image':Image
    };
  }
}