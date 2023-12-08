import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../themepage/theme.dart';
import '../add/add_meeting.dart';
import '../detail/notification_detail.dart';

class MeetingTab extends StatefulWidget {
  final String id;
  const MeetingTab({super.key, required this.id});
  @override
  State<MeetingTab> createState() => MeetingTabState();
}

class MeetingTabState extends State<MeetingTab> {
  final firestore = FirebaseFirestore.instance;
  String? roomDataId;
  String? userindex;

  var scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('Biginfo')
                .doc(widget.id)
                .collection('meetings')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final docs = snapshot.data!.docs;

              if (docs.isNotEmpty) {
                final roomData = docs.toList();

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    List<String> images =
                        List.castFrom(roomData[index]['images']);
                    return GestureDetector(
                      onTap: () {
                        debugPrint(roomData[index]['id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationDetail(
                              roomId: widget.id,
                              docId: roomData[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roomData[index]['title'],
                              style: blackw700.copyWith(fontSize: 18),
                            ),
                            if (images.isNotEmpty)
                              Container(
                                height: 100, // 이미지 높이 조절
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal, // 수평으로 스크롤
                                  itemCount: images.length,
                                  itemBuilder: (context, imageIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Image.network(
                                        images[imageIndex],
                                        height: 80, // 이미지 높이 조절
                                        width: 80, // 이미지 너비 조절
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('No data found.');
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMeeting(
                    id: widget.id,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const SizedBox(
              width: 343,
              height: 45,
              child: Center(
                child: Text(
                  '모임 기록하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
