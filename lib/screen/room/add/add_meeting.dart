import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../themepage/theme.dart';

class AddMeeting extends StatefulWidget {
  final String id;

  const AddMeeting({
    required this.id,
    super.key,
  });

  @override
  State<AddMeeting> createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

  final TextEditingController _titleController = TextEditingController();
  bool _isTextFieldEmpty = true;
  String _enteredText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('모임 기록하기'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Text('제목을 입력해 주세요'),
              TextFormField(
                maxLength: 15,
                key: const ValueKey(1),
                style: blackw500.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  //준) 선택되지 않은 밑줄 속성
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  //준) 선택된 밑줄 속성 둘을 일치시켰음
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  hintText: "예) 15주차 팀모임",
                  hintStyle: greyw500.copyWith(fontSize: 14),
                  suffixIcon: _isTextFieldEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.cancel),
                          iconSize: 15,
                          color: Colors.grey,
                          onPressed: () {
                            _titleController.clear();
                            setState(() {
                              _enteredText = '';
                              _isTextFieldEmpty = true;
                            });
                          },
                        ),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredText = value;
                    _isTextFieldEmpty = value.isEmpty;
                  });
                },
                onSaved: (value) {
                  _enteredText = value!;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(227, 255, 217, 1),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 5)
                    ],
                  ),
                  child: IconButton(
                      onPressed: () async {
                        multiImage = await picker.pickMultiImage();
                        setState(() {
                          //갤러리에서 가지고 온 사진들은 리스트 변수에 저장되므로 addAll()을 사용해서 images와 multiImage 리스트를 합쳐줍니다.
                          images.addAll(multiImage);
                          _uploadImageToFirebase();
                          for (var xFile in multiImage) {
                            if (xFile != null) {
                              print(xFile.path);
                            }
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                        color: Colors.black54,
                      ))),
              Container(
                margin: const EdgeInsets.all(10),
                child: GridView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount:
                      images.length, //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
                    childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
                                  image: FileImage(File(images[index]!
                                          .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                                      )))),
                        ),
                        Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //삭제 버튼
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 15),
                              onPressed: () {
                                //버튼을 누르면 해당 이미지가 삭제됨
                                setState(() {
                                  images.remove(images[index]);
                                });
                              },
                            ))
                      ],
                    );
                  },
                ),
              ),
              Container(
                width: 343,
                height: 45,
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: ElevatedButton(
                  onPressed: () async {
                    final docRef = FirebaseFirestore.instance
                        .collection("Biginfo")
                        .doc(widget.id);
                    final notificationRef = docRef.collection("meetings").doc();
                    await notificationRef.set({
                      "title": _enteredText,
                      "images": uploadedImageUrls,
                      "id": notificationRef.id,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                      ),
                      backgroundColor: const Color.fromRGBO(54, 209, 0, 1)),
                  child: const Text(
                    '완료하기',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<String> uploadedImageUrls = []; // List to store uploaded image URLs

  _uploadImageToFirebase() async {
    // 선택한 이미지들이 있는지 확인
    if (multiImage.isEmpty) {
      if (kDebugMode) {
        debugPrint('이미지가 선택되지 않았습니다.');
      }
      return;
    }

    try {
      for (var xFile in multiImage) {
        if (xFile != null) {
          // 선택한 파일에서 이미지 데이터 읽기
          final imageBytes = await File(xFile.path).readAsBytes();

          // Firebase Storage에 이미지를 업로드할 위치에 대한 참조 생성
          final imageName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
          final storageReference = FirebaseStorage.instance.ref(imageName);

          // 이미지를 Firebase Storage에 업로드
          await storageReference.putData(imageBytes);

          // 업로드된 이미지의 URL 가져오기
          final TaskSnapshot taskSnapshot =
              await storageReference.putData(imageBytes);
          final imageUrl = await taskSnapshot.ref.getDownloadURL();

          // 업로드 된 이미지 URL 저장 또는 활용
          setState(() {
            uploadedImageUrls.add(imageUrl);
          });

          if (kDebugMode) {
            debugPrint('이미지 업로드 성공');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('이미지 업로드 실패: $e');
      }
    }
  }
}
