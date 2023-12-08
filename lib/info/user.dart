import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  static String? userName;
  static String? userNameInFireStore;
  static String? userEmail;
  static String? userEmailInFireStore;
  static String? userJob;

  static String? userPassword;
  static String? userPasswordInFireStore;
  static String? userId;
  static String? userIdInFireStore;
}

class JoyUser {
  JoyUser({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userId,
  });

  final String? userName;
  final String? userEmail;
  final String? userPassword;
  final String? userId;

  factory JoyUser.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return JoyUser(
        userName: snapshotData[userNameFieldName],
        userEmail: snapshotData[userEmailFieldName],
        userPassword: snapshotData[userPasswordFieldName],
        userId: snapshotData[userIdFieldName]);
  }
}

const String userNameFieldName = "userName";
const String userEmailFieldName = "userEamil";
const String userPasswordFieldName = "userPassword";
const String userIdFieldName = "userId";
