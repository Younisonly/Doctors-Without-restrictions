import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

class FireStoreUser {
  final CollectionReference _userCollectionRef =
  FirebaseFirestore.instance.collection('Users');


  Future<void> addUserToFireStore(UserModel userModel) async {
    return await _userCollectionRef
        .doc(userModel.userId)
        .set(userModel.toJson());
  }
}

