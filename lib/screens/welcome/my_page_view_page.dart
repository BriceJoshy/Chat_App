import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../splash_screen.dart';

class myPageViewPage extends StatelessWidget {
  final String content;
  final Image image;
  final String pgNum;

  const myPageViewPage({
    super.key,
    required this.content,
    required this.image,
    required this.pgNum,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 25),
      child: Column(
        children: [
          image,
          SizedBox(height: mq.height * 0.1),
          Text(
            content,
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(fontSize: 25),
          ),
          SizedBox(height: mq.height * 0.15),
          Row(
            children: [
              SizedBox(
                width: mq.width * 0.45,
              ),
              Text(pgNum),
              SizedBox(
                width: mq.width * 0.2,
              ),
              Image.asset(
                'assets/images/arrow.gif',
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class myPageViewLastPage extends StatefulWidget {
  const myPageViewLastPage({super.key});

  @override
  State<myPageViewLastPage> createState() => _myPageViewLastPageState();
}

class _myPageViewLastPageState extends State<myPageViewLastPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 25),
      child: Column(
        children: [
          Image.asset('assets/images/wel_3.gif'),
          SizedBox(height: mq.height * 0.1),
          Text(
            "Chat with you're favourite people 😍",
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(fontSize: 25),
          ),
          SizedBox(height: mq.height * 0.2),
          Row(
            children: [
              SizedBox(
                width: mq.width * 0.45,
              ),
              const Text("3/3"),
              SizedBox(
                width: mq.width * 0.1,
              ),
              SizedBox(
                height: mq.height * 0.06,
                width: mq.width * 0.3,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const login_screen()));
                    },
                    child: const Text(
                      "Lets Go!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
