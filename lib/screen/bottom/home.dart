import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mo_final/screen/bottom/entrance.dart';

import '../../info/user.dart';
import '../../themepage/theme.dart';
import '../room/room.dart';
import '../create/room_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _roomNameController = TextEditingController();
  bool _isTextFieldEmpty = true;
  String _enteredText = '';
  @override
  void initState() {
    super.initState();
    _textFieldFocus.addListener(_updateTextFieldState);
  }

  @override
  void dispose() {
    _textFieldFocus.removeListener(_updateTextFieldState);
    _textFieldFocus.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  void _updateTextFieldState() {
    setState(() {
      _enteredText = _roomNameController.text;
      _isTextFieldEmpty = _enteredText.isEmpty;
    });
  }

  bool isConfirmButtonEnabled = false;

  String? name;
  List<String> roomCode = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 66),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '나의 공동체',
                      style: blackw700.copyWith(fontSize: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          IconButton(
              onPressed: () {
                _showBottomSheet(context, '1');
              },
              icon: const Icon(Icons.add)),
          Container(
            margin: const EdgeInsets.only(top: 23, left: 25),
            height: 448,
            width: 393,
            child: const Tabbarviewinmoa(),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(23.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 25, top: 25),
                child: const Text(
                  '공동체 시작하기',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetRoomTitle()),
                    );
                  },
                  icon: const ImageIcon(
                    size: 18,
                    color: Colors.black,
                    AssetImage('assets/images/plus.png'),
                  ),
                  label: Text('팀 생성하기',
                      style:
                          blackw500.copyWith(fontSize: 16, letterSpacing: -1)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showEnterRoomBottomSheet(context);
                  },
                  icon: const ImageIcon(
                    size: 18,
                    color: Colors.black,
                    AssetImage('assets/images/key.png'),
                  ),
                  label: Text('팀 코드로 입장하기',
                      style:
                          blackw500.copyWith(fontSize: 16, letterSpacing: -1)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEnterRoomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateInside) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  Container(
                    margin: const EdgeInsets.only(left: 25, top: 14),
                    child: Text('팀 입장하기',
                        style: blackw700.copyWith(
                            fontSize: 18, letterSpacing: -1)),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '팀 코드',
                              style: greyw500.copyWith(
                                fontSize: 14,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          maxLength: 4,
                          controller: _roomNameController,
                          style: blackw500.copyWith(
                              fontSize: 24, letterSpacing: -1.5),
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFEFEFEF)), // 원하는 색상으로 변경
                            ),
                            hintText: '입력해주세요',
                            hintStyle: greyw500.copyWith(
                                fontSize: 24, letterSpacing: -1.5),
                            contentPadding: const EdgeInsets.fromLTRB(
                                0, 20, 0, 10), // 상하 여백 조정
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              isConfirmButtonEnabled = value.length == 4;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 343,
                    height: 45,
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    child: ElevatedButton(
                      onPressed: () async {
                        final roomCodeText = _roomNameController.text;
                        _roomNameController.clear();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Entrance(code: roomCodeText)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                          ),
                          backgroundColor: Theme.of(context).primaryColor),
                      child: Text(
                        '입장하기',
                        style: whitew700.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Tabbarviewinmoa extends StatefulWidget {
  const Tabbarviewinmoa({super.key});
  @override
  State<Tabbarviewinmoa> createState() => TabbarviewinmoaState();
}

final firestore = FirebaseFirestore.instance;

class TabbarviewinmoaState extends State<Tabbarviewinmoa>
    with SingleTickerProviderStateMixin {
  bool isConfirmButtonEnabled = false;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();

    if (UserProvider.userName != null) {
      name = UserProvider.userName;
    }
  }

  String? name;
  List<String> roomCode = [];
  final TextEditingController _roomNameController = TextEditingController();
  var scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection('Biginfo').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        final filteredDocs = docs
            .where((doc) =>
                (doc['users_id'] as List?)
                    ?.contains(FirebaseAuth.instance.currentUser!.uid) ??
                false)
            .toList();
        if (filteredDocs.isNotEmpty) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true, // Prevents the ListView from scrolling
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room(
                        id: filteredDocs[index]['id'] as String,
                      ),
                    ),
                  );
                },
                child: Card(
                  shadowColor: Colors.transparent,
                  child: Container(
                    width: 299,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit
                            .cover, // Make the image cover the entire container
                        image: NetworkImage(
                          filteredDocs[index]['roomImage'] as String,
                        ),
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), // 여기서 색상과 투명도 조절 가능
                          BlendMode.darken, // 원하는 블렌드 모드 선택
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20), // Adding some padding at the top
                            child: Text(
                              filteredDocs[index]['title'] as String,
                              style: whitew700.copyWith(fontSize: 24),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              try {
                                // Replace "Biginfo" with the actual collection name
                                await FirebaseFirestore.instance
                                    .collection("Biginfo")
                                    .doc(filteredDocs[index]['id'])
                                    .delete();
                              } catch (e) {
                                debugPrint("Error deleting document: $e");
                              }
                            },
                            child: SizedBox(
                              width: 30,
                              height: 18,
                              child: Image.asset('assets/images/kebap.png'),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 132,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3), // 반지름 값을 설정합니다.
                                  color: const Color.fromRGBO(255, 239, 244, 1),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 12, bottom: 3),
                                      child: Text(
                                        filteredDocs[index]['mission']
                                            as String,
                                        style: pinkw700.copyWith(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(right: 47, left: 22),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: 299,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Column(
                      children: [
                        const SizedBox(height: 120),
                        const Text(
                          '효율적인',
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.48),
                        ),
                        const Text(
                          '팀 관리를 해보세요',
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.48),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet(context, '1');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: const Color(0xFFFFFFFF),
                            backgroundColor: const Color.fromRGBO(
                                54, 209, 0, 1), // 버튼 내의 아이콘과 텍스트 색상
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // 모서리 보더 반경
                            ),
                            minimumSize: const Size(267, 45), // 버튼 크기 설정
                          ),
                          child: const Text(
                            '함께 하기',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 18, // 폰트 크기
                                fontWeight: FontWeight.w700, // 폰트 무게
                                color: Color(0xFFFFFFFF),
                                letterSpacing: -0.36 // 글씨 색
                                ),
                          ),
                        ),
                        const SizedBox(height: 18)
                      ],
                    ))),
              ],
            ),
          );
        }
      },
    );
  }

  void _showBottomSheet(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(23.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 25, top: 25),
                child: const Text(
                  '공동체 시작하기',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetRoomTitle()),
                    );
                  },
                  icon: const ImageIcon(
                    size: 18,
                    color: Colors.black,
                    AssetImage('assets/images/plus.png'),
                  ),
                  label: Text('팀 생성하기',
                      style:
                          blackw500.copyWith(fontSize: 16, letterSpacing: -1)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showEnterRoomBottomSheet(context);
                  },
                  icon: const ImageIcon(
                    size: 18,
                    color: Colors.black,
                    AssetImage('assets/images/key.png'),
                  ),
                  label: Text('팀 코드로 입장하기',
                      style:
                          blackw500.copyWith(fontSize: 16, letterSpacing: -1)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEnterRoomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateInside) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  Container(
                    margin: const EdgeInsets.only(left: 25, top: 14),
                    child: Text('팀 입장하기',
                        style: blackw700.copyWith(
                            fontSize: 18, letterSpacing: -1)),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '팀 코드',
                              style: greyw500.copyWith(
                                fontSize: 14,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          maxLength: 4,
                          controller: _roomNameController,
                          style: blackw500.copyWith(
                              fontSize: 24, letterSpacing: -1.5),
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFEFEFEF)), // 원하는 색상으로 변경
                            ),
                            hintText: '입력해주세요',
                            hintStyle: greyw500.copyWith(
                                fontSize: 24, letterSpacing: -1.5),
                            contentPadding: const EdgeInsets.fromLTRB(
                                0, 20, 0, 10), // 상하 여백 조정
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              isConfirmButtonEnabled = value.length == 4;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 343,
                    height: 45,
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    child: ElevatedButton(
                      onPressed: () async {
                        final roomCodeText = _roomNameController.text;
                        _roomNameController.clear();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Entrance(code: roomCodeText)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 버튼 모서리 둥글기 설정
                          ),
                          backgroundColor: Theme.of(context).primaryColor),
                      child: Text(
                        '입장하기',
                        style: whitew700.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
