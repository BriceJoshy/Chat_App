// this is a snack bar which is globally called in the app

// static member means they are created only once and does'nt
// require an object of class for acessing
// void cuz nothing is returned
// calling build context for snackbar and a message to show
import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg, String msg1) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 120,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  )),
              child: Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        msg1,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Center(
                          child: Image.asset(
                        'assets/images/error_cat_image.png',
                        height: 50,
                        color: Colors.black,
                      )),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -20,
              left: 0,
              child: Image.asset(
                'assets/images/error_corner.png',
                height: 60,
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
