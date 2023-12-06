import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mo_final/screen/room/detail/adjustment_detail.dart';

import '../add/add_adjustment.dart';

class AdjustmentTab extends StatefulWidget {
  final String id;
  const AdjustmentTab({super.key, required this.id});
  @override
  State<AdjustmentTab> createState() => _AdjustmentTabState();
}

class _AdjustmentTabState extends State<AdjustmentTab> {
  final firestore = FirebaseFirestore.instance;
  String? eventDataId;
  String? userindex;

  var scroll = ScrollController();
  var format = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('Biginfo')
                .doc(widget.id)
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

              if (docs.isNotEmpty) {
                final eventData = docs.toList();

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final eventPrice = format
                        .format(double.parse(eventData[index]['price']))
                        .toString();
                    return GestureDetector(
                      onTap: () {
                        debugPrint(eventData[index]['id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdjustmentDetail(
                              eventId: widget.id,
                              docId: eventData[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 25),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(227, 255, 217, 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventData[index]['title'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff248900)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("$eventPrice 원",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ],
                          ),
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
                  builder: (context) => AddAdjustment(
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
                  '정산 요청하기',
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
