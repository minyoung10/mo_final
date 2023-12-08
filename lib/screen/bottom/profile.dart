import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../info/user.dart';
import '../../themepage/theme.dart';
import '../account/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 76),
            color: const Color(0xFFFAFAFA),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            Text(
                              '나의 프로필',
                              style: blackw500.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 90, // 이미지 높이를 90으로 제한
                      //   child: Image.asset(
                      //     'assets/images/Profile.jpg', // 이미지 URL을 여기에 넣으세요
                      //     fit: BoxFit.cover, // 이미지를 채우면서 자르거나 늘림
                      //   ),
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('광진',
                          style: blackw700.copyWith(
                            fontSize: 24,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${UserProvider.userName}',
                        style: blackw500.copyWith(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 버튼이 클릭되었을 때 수행할 동작
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFF9F9F9),
                          fixedSize: const Size(343, 38), // 배경색 설정 (#F9F9F9)
                        ),
                        child: Text('프로필 수정',
                            style: blackw700.copyWith(
                              fontSize: 15.0,
                            )),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                    ],
                  ),
                ),
                //두번째 컨테이너
                Container(
                  color: const Color(0xFFFAFAFA),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 버튼이 클릭되었을 때 수행할 동작
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(343, 66),
                          backgroundColor: const Color(0xFFFFFFFF), // 버튼 크기 설정
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 모서리 둥글기 설정
                          ), // 배경색 설정 (#FFFFFF)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('버전정보',
                                style: blackw500.copyWith(
                                  fontSize: 16.0,
                                )),
                            Text('v 1.0',
                                style: blackw500.copyWith(
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 버튼이 클릭되었을 때 수행할 동작
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(343, 66),
                          backgroundColor: const Color(0xFFFFFFFF), // 버튼 크기 설정
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 모서리 둥글기 설정
                          ), // 배경색 설정 (#FFFFFF)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('앱 소식 및 설명서',
                                style: blackw500.copyWith(
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 버튼이 클릭되었을 때 수행할 동작
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(343, 66),
                          backgroundColor: const Color(0xFFFFFFFF), // 버튼 크기 설정
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 모서리 둥글기 설정
                          ), // 배경색 설정 (#FFFFFF)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('문의하기',
                                style: blackw500.copyWith(
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 버튼이 클릭되었을 때 수행할 동작
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(343, 66),
                          backgroundColor: const Color(0xFFFFFFFF), // 버튼 크기 설정
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 모서리 둥글기 설정
                          ), // 배경색 설정 (#FFFFFF)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('앱 오류 신고하기',
                                style: blackw500.copyWith(
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 25),
                        child: Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const LoginPage())));
                              },
                              style: TextButton.styleFrom(),
                              child: Text(
                                '로그아웃',
                                style: greyw500.copyWith(
                                  fontSize: 14.0,
                                  decoration: TextDecoration.underline,
                                  color: const Color(0xFF808080),
                                  decorationColor: const Color(0xFF808080),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
