// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../info/big.dart';
import '../../info/user.dart';
import '../../themepage/theme.dart';
import '../room/room.dart';

class RoomImageSet extends StatefulWidget {
  const RoomImageSet({super.key});
  @override
  State<RoomImageSet> createState() => _RoomImageSetState();
}

class _RoomImageSetState extends State<RoomImageSet> {
  int? selectedDropdownValue; // 드롭다운에서 선택된 값을 저장하는 변수
  String selectedDropdownText = ''; // 기본 값 설정

  XFile? _pickedFile;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateInside) {
        if (_pickedFile != null) {
          return Container(
            height: 485,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 18),
                    width: 48,
                    height: 3.346,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAAAAAA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25, top: 26),
                  child: const Text(
                    '방에 들어갈 이미지는 무엇인가요?',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: const Text(
                    "이미지를 가져올 곳을 선택해주세요",
                    style: TextStyle(
                        color: Color.fromRGBO(170, 170, 170, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                    onTap: () {
                      _getPhotoLibraryImage();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 343,
                          height: 256,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: FileImage(File(_pickedFile!.path)),
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 38),
                        Container(
                          width: 343,
                          height: 45,
                          margin: const EdgeInsets.only(left: 25, right: 25),
                          child: ElevatedButton(
                            onPressed: () async {
                              _generateRandom4Digit();
                              final docRef = FirebaseFirestore.instance
                                  .collection("Biginfo")
                                  .doc();
                              await docRef.set({
                                registerTimeFieldName:
                                    FieldValue.serverTimestamp(),
                                idFieldName: docRef.id,
                                "title": BigInfoProvider.title,
                                "mission": BigInfoProvider.mission,
                                "roomImage": BigInfoProvider.roomImage,
                                "code": BigInfoProvider.code,
                                "users_id": [
                                  FirebaseAuth.instance.currentUser!.uid
                                ],
                                "users_name": [UserProvider.userName],
                                'users_job': {
                                  UserProvider.userName: BigInfoProvider.job
                                },
                              });
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room(
                                    id: docRef.id,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // 버튼 모서리 둥글기 설정
                                ),
                                backgroundColor:
                                    const Color.fromRGBO(54, 209, 0, 1)),
                            child: const Text(
                              '완료하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 16.0),
              ],
            ),
          );
        } else {
          return Container(
            height: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: 48,
                    height: 3.346,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAAAAAA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  margin: const EdgeInsets.only(left: 25, top: 14),
                  child: Text(
                    '방에 들어갈 이미지는 무엇인가요?',
                    style: blackw700.copyWith(fontSize: 18, letterSpacing: -1),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: Text(
                    "이미지를 가져올 곳을 선택해주세요",
                    style: greyw500.copyWith(fontSize: 14, letterSpacing: -1),
                  ),
                ),
                Container(
                  width: 343,
                  height: 60,
                  margin: const EdgeInsets.only(left: 25, right: 25, top: 38),
                  child: ElevatedButton(
                    onPressed: () {
                      _getPhotoLibraryImage();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                        ),
                        elevation: 0, // 이 부분을 추가하여 쉐도우 없앰
                        backgroundColor: const Color.fromRGBO(54, 209, 0, 0.2)),
                    child: const Text(
                      '갤러리',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(54, 209, 0, 1)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _generateRandom4Digit() {
    final random = Random();
    int fourDigitRandom = random.nextInt(10000); // 0부터 9999까지의 난수 생성
    String formattedRandom = fourDigitRandom.toString().padLeft(4, '0');
    BigInfoProvider.code = formattedRandom;
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      _uploadImageToFirebase();
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  String? _uploadedImageUrl; // 업로드 된 이미지 URL 저장 변수 추가

  _uploadImageToFirebase() async {
    await Firebase.initializeApp();
    // 선택한 이미지가 있는지 확인
    if (_pickedFile == null) {
      if (kDebugMode) {
        print('이미지가 선택되지 않았습니다.');
      }
      return;
    }
    // 선택한 파일에서 이미지 데이터 읽기
    final imageBytes = await File(_pickedFile!.path).readAsBytes();
    // Firebase Storage에 이미지를 업로드할 위치에 대한 참조 생성
    final imageName = '${DateTime.now().microsecond}.jpg';
    final storageReference = FirebaseStorage.instance.ref(imageName);

    try {
      // 이미지를 Firebase Storage에 업로드
      await storageReference.putData(imageBytes);
      final TaskSnapshot taskSnapshot =
          await storageReference.putData(imageBytes);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _uploadedImageUrl = imageUrl; // 업로드 된 이미지 URL 저장
        BigInfoProvider.roomImage = _uploadedImageUrl;
      });
      if (kDebugMode) {
        print('이미지 업로드 성공\n');
      }
    } catch (e) {
      if (kDebugMode) {
        print('이미지 업로드 실패: $e');
      }
    }
  }
}
