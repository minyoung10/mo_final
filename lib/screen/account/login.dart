import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../themepage/theme.dart';
import '../bottom/bottom.dart';

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPage> {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        OAuthCredential googleCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        UserCredential credential =
            await FirebaseAuth.instance.signInWithCredential(googleCredential);
        final User? user = credential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .set(<String, dynamic>{
            'email': googleUser.email,
            'name': googleUser.displayName,
            'status_message': "I promise to take the test honestly before GOD",
            'uid': user.uid,
          });
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      );
    } catch (e) {
      debugPrint("Google 로그인 오류: $e");
    }
  }
  Future<void> signInWithAnonymous() async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInAnonymously();
      User? user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .set(<String, dynamic>{
          'status_message': "I promise to take the test honestly before GOD",
          'uid': user.uid,
        });
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          debugPrint("Unknown error.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                signInWithGoogle(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: const Color.fromRGBO(54, 209, 0, 1),
                backgroundColor: const Color.fromRGBO(54, 209, 0, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(343, 52),
              ),
              child: Text('구글 로그인', style: whitew700.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signInWithAnonymous();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromRGBO(54, 209, 0, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(343, 52),
              ),
              child: Text('익명 로그인', style: whitew700.copyWith(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
