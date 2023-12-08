import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../themepage/theme.dart';
import '../../bottom/home.dart';
import '../edit/notification_edit.dart';

class NotificationDetail extends StatefulWidget {
  final String roomId;
  final String docId;

  const NotificationDetail({
    super.key,
    required this.roomId,
    required this.docId,
  });

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection('Biginfo')
            .doc(widget.roomId)
            .collection('notifications')
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
            final roomSnapshot = filteredDocs.first;
            final roomData = roomSnapshot.data();
            final image = roomData['image'] as String;
            final title = roomData['title'] as String;
            final content = roomData['context'] as String;
            final writer = roomData['writer'] as String;
            final job = roomData['job'] as String;

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
                title: const Text('공지'),
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
                                roomId: widget.roomId,
                                docId: widget.docId,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Biginfo')
                              .doc(widget.roomId)
                              .collection('notifications')
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
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 343,
                        height: 256,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            image,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 27),
                      Row(
                        children: [
                          Text(title,
                              style: blackw700.copyWith(
                                fontSize: 18,
                              )),
                          const Spacer(),
                          Text(
                            '$writer ($job)',
                            style: blackw500.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 343,
                        height: 256,
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        color: const Color.fromRGBO(227, 255, 217, 1), // 연두색 설정
                        child: Text(
                          content,
                          style: blackw500.copyWith(fontSize: 16),
                        ),
                      ),
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
