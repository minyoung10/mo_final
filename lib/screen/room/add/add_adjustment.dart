import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../themepage/theme.dart';

class AddAdjustment extends StatefulWidget {
  final String id;

  const AddAdjustment({super.key, required this.id});

  @override
  State<AddAdjustment> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddAdjustment> {
  int? selectedDropdownValue; // 드롭다운에서 선택된 값을 저장하는 변수
  String selectedDropdownText = ''; // 기본 값 설정
  List<String> memberList = [];

  final TextEditingController _titleController = TextEditingController();
  bool _isTextFieldEmpty = true;
  String _enteredText = '';

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  Future<void> fetchMemberList() async {
    final docSnapshot = await FirebaseFirestore.instance.collection("Biginfo").doc(widget.id).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      debugPrint("${data["users_id"]}");
      setState(() {
        memberList = List<String>.from(data['users_id'] ?? []);
      });
      debugPrint("memberList: $memberList");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정산 작성'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('제목을 입력해 주세요'),
              TextFormField(
                maxLength: 15,
                style: blackw500.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  hintText: "예) BBQ 회비 정산",
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
              const Text('정산 금액을 입력해 주세요.'),
              TextFormField(
                controller: _priceController,
                maxLength: 15,
                style: blackw500.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  hintText: "예) 10000",
                  hintStyle: greyw500.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              const Text('입금자명을 입력해 주세요.'),
              TextFormField(
                controller: _peopleController,
                maxLength: 15,
                style: blackw500.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                  ),
                  hintText: "예) 정광진",
                  hintStyle: greyw500.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              const Text('정산 멤버를 추가해 주세요.'),
              
              const SizedBox(height: 40),
              Container(
                width: 343,
                height: 45,
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: ElevatedButton(
                  onPressed: () async {
                    final docRef = FirebaseFirestore.instance
                        .collection("Smallinfo")
                        .doc(widget.id);
                    
                    final adjustmentRef =
                        docRef.collection("adjustments").doc();
                    await adjustmentRef.set({
                      "title": _enteredText,
                      "price": _priceController.text,
                      "id": adjustmentRef.id,
                      "people": _peopleController.text,
                      "paylist": [],
                      "payed":[]
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
        ),
      ),
    );
  }
}
