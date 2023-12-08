import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mo_final/info/user.dart';

import '../../info/big.dart';
import '../../themepage/theme.dart';
import '../create/create_image.dart';
import '../room/room.dart';
import 'home.dart';

class Entrance extends StatefulWidget {
  final String code;
  const Entrance({
    super.key,
    required this.code,
  });
  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance> {
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  bool _isTextFieldEmpty = true;
  String _enteredText = '';
  int _selectedButtonIndex = -1; //0,1,2 버튼 중에 무엇이 선택되었는지의 정보
  @override
  void initState() {
    super.initState();
    _textFieldFocus.addListener(_updateTextFieldState);
  }

  @override
  void dispose() {
    _textFieldFocus.removeListener(_updateTextFieldState);
    _textFieldFocus.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _updateTextFieldState() {
    setState(() {
      _enteredText = _textEditingController.text;
      _isTextFieldEmpty = _enteredText.isEmpty;
    });
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (!_isTextFieldEmpty) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _handleKeyPress,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffFFEFF4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        height: 4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("팀에서 어떤 직책을 맡고 있나요?",
                        style: blackw700.copyWith(
                          fontSize: 24,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "1가지만 선택할 수 있어요",
                      style:
                          greyw500.copyWith(fontSize: 16, letterSpacing: -0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 88.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: _selectedButtonIndex == 0
                        ? const Color.fromRGBO(54, 209, 0, 0.2)
                        : const Color(
                            0xFFFAFAFA), // Updated colo// Updated color
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Text(
                          "팀장",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.36,
                            color: _selectedButtonIndex == 0
                                ? const Color.fromRGBO(54, 209, 0, 1)
                                : const Color(0xFF242625),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: _selectedButtonIndex == 1
                        ? const Color.fromRGBO(54, 209, 0, 0.2)
                        : const Color(0xFFFAFAFA), // Updated color
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Text(
                          "부팀장",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.36,
                            color: _selectedButtonIndex == 1
                                ? const Color.fromRGBO(54, 209, 0, 1)
                                : const Color(0xFF242625),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: _selectedButtonIndex == 2
                        ? const Color.fromRGBO(54, 209, 0, 0.2)
                        : const Color(0xFFFAFAFA), // Updated color
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Text(
                          "회계",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.36,
                            color: _selectedButtonIndex == 2
                                ? const Color.fromRGBO(54, 209, 0, 1)
                                : const Color(0xFF242625),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 3;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: _selectedButtonIndex == 3
                        ? const Color.fromRGBO(54, 209, 0, 0.2)
                        : const Color(0xFFFAFAFA), // Updated color
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Text(
                          "서기",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.36,
                            color: _selectedButtonIndex == 3
                                ? const Color.fromRGBO(54, 209, 0, 1)
                                : const Color(0xFF242625),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 4;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 60),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: _selectedButtonIndex == 4
                        ? const Color.fromRGBO(54, 209, 0, 0.2)
                        : const Color(0xFFFAFAFA), // Updated color
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Text(
                          "팀원",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.36,
                            color: _selectedButtonIndex == 4
                                ? const Color.fromRGBO(54, 209, 0, 1)
                                : const Color(0xFF242625),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  // 마지막
                  onPressed: _selectedButtonIndex != -1 //기본 상태가 아니면
                      ? () async {
                          if (_selectedButtonIndex == 0) {
                            BigInfoProvider.job = '팀장';
                          } else if (_selectedButtonIndex == 1) {
                            BigInfoProvider.job = "부팀장";
                          } else if (_selectedButtonIndex == 2) {
                            BigInfoProvider.job = "회계";
                          } else if (_selectedButtonIndex == 3) {
                            BigInfoProvider.job = "서기";
                          } else if (_selectedButtonIndex == 4) {
                            BigInfoProvider.job = "팀원";
                          }
                          final querySnapshot = await firestore
                              .collection('Biginfo')
                              .where('code', isEqualTo: widget.code)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            final roomId = querySnapshot.docs[0].id;
                            final roomDoc =
                                firestore.collection('Biginfo').doc(roomId);
                            await roomDoc.update({
                              "users_id": FieldValue.arrayUnion(
                                  [FirebaseAuth.instance.currentUser!.uid]),
                              "users_job.${UserProvider.userName}":
                                  BigInfoProvider.job,
                              "users_name":
                                  FieldValue.arrayUnion([UserProvider.userName])
                            });
                            roomDoc.get().then((docSnapshot) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room(
                                    id: roomId,
                                  ),
                                ),
                              );
                            }).catchError((error) {
                              debugPrint('Error getting document: $error');
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 45),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "다음으로",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEnterRoomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return const RoomImageSet();
      },
    );
  }
}
