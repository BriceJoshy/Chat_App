import 'package:flutter/material.dart';
import 'my_page_view_page.dart';

class get_started extends StatefulWidget {
  const get_started({super.key});

  @override
  State<get_started> createState() => _get_startedState();
}

class _get_startedState extends State<get_started> {
  final _controller = PageController(initialPage: 0);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _controller,
          children: [
            myPageViewPage(
              content:
                  "Chat in Which ever language you're comfortable with          😊",
              image: Image.asset("assets/images/wel_1.gif"),
              pgNum: '1/3',
            ),
            myPageViewPage(
              content:
                  "Chat anywhere, anytime at you're own comfort                     😘",
              image: Image.asset("assets/images/wel_2.gif"),
              pgNum: '2/3',
            ),
            const myPageViewLastPage()
          ],
        ),
      ),
    );
  }
}
