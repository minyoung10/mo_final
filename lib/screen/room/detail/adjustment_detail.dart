import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import '../../../themepage/theme.dart';
import '../../bottom/home.dart';
import '../edit/notification_edit.dart';

class AdjustmentDetail extends StatefulWidget {
  final String eventId;
  final String docId;

  const AdjustmentDetail({
    super.key,
    required this.eventId,
    required this.docId,
  });

  @override
  State<AdjustmentDetail> createState() => _AdjustmentDetailState();
}

class _AdjustmentDetailState extends State<AdjustmentDetail> {
  User? user = FirebaseAuth.instance.currentUser;
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String scannedText = ""; // textRecognizer로 인식된 텍스트를 담을 String
  bool isMatched = false;
  String people = "";
  String money = "";

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
      getRecognizedText(_image!); // 이미지를 가져온 뒤 텍스트 인식 실행
    }
  }

  void getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);

    // textRecognizer 초기화, 이때 script에 인식하고자하는 언어를 인자로 넘겨줌
    // ex) 영어는 script: TextRecognitionScript.latin, 한국어는 script: TextRecognitionScript.korean
    final textRecognizer =
        GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.korean);

    // 이미지의 텍스트 인식해서 recognizedText에 저장
    RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Release resources
    await textRecognizer.close();

    // 인식한 텍스트 정보를 scannedText에 저장
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    setState(() {
      RegExp peopleExp = RegExp(r"(.*) 님께");
      people = peopleExp.firstMatch(scannedText)!.group(1)!;

// '원' 앞에 있는 숫자를 찾는 정규 표현식
      RegExp moneyExp = RegExp(r"(\d+)원");
      money = moneyExp.firstMatch(scannedText)!.group(1)!;

      debugPrint('people: $people');
      debugPrint('money: $money');
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection('Smallinfo')
            .doc(widget.eventId)
            .collection('adjustments')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;
          final filteredDocs =
              docs.where((doc) => doc['id'] == widget.docId).toList();
          if (filteredDocs.isNotEmpty) {
            final eventSnapshot = filteredDocs.first;
            final eventData = eventSnapshot.data();
            final String eventTitle = eventData['title'];
            final String price = eventData['price'];
            final String name = eventData['people'];
            final List<String> payedList =
                List<String>.from(eventData['payed']);
            final bool isPayed = payedList.contains(user!.uid);

            return Scaffold(
              appBar: AppBar(
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                title: Text(eventTitle),
                actions: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.create),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNotification(
                                roomId: widget.eventId,
                                docId: widget.docId,
                              ),
                            ),
                          );
                        },
                      ),
                      _image != null
                          ? Image.file(File(_image!.path),
                              width: double.infinity,
                              height: 350,
                              fit: BoxFit.fill)
                          : IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Smallinfo')
                                    .doc(widget.eventId)
                                    .collection('adjustments')
                                    .doc(widget.docId)
                                    .delete();
                                Navigator.pop(context);
                              },
                            ),
                      const SizedBox(width: 13)
                    ],
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      isPayed
                          ? Container(
                              width: 343,
                              height: 256,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              color: const Color.fromRGBO(
                                  227, 255, 217, 1), // 연두색 설정
                              child: Text(
                                price,
                                style: blackw500.copyWith(fontSize: 16),
                              ),
                            )
                          : Container(
                              width: 343,
                              height: 256,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              color: const Color.fromRGBO(
                                  227, 255, 217, 1), // 연두색 설정
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("정산 화면을 인증해주세요!"),
                                  const SizedBox(height: 20),
                                  IconButton(
                                      onPressed: () {
                                        getRecognizedText(_image!);
                                        debugPrint("$people, $money");
                                        if (people == name && money == price) {
                                          isMatched = true;
                                        } else {
                                          isMatched = false;
                                        }
                                      },
                                      icon: const Icon(Icons.camera_alt),
                                      iconSize: 30)
                                ],
                              )),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text('');
          }
        });
  }
}
