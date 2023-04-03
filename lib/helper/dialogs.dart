// this is a snack bar which is globally called in the app

// static member means they are created only once and does'nt
// require an object of class for acessing
// void cuz nothing is returned
// calling build context for snackbar and a message to show
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg, String msg1) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                  color: Color(0xffc72c41),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
              child: Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          msg1,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(20)),
                child: SvgPicture.asset(
                  "assets/images/bubbles.svg",
                  height: 48,
                  width: 40,
                  // ignore: deprecated_member_use
                  color: const Color(0xff801336),
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/fail.svg',
                    height: 40,
                  ),
                  Positioned(
                      top: 10,
                      child: SvgPicture.asset(
                        "assets/images/close.svg",
                        height: 16,
                      ))
                ],
              ),
            )
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
