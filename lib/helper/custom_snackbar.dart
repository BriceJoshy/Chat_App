// this is a snack bar which is globally called in the app

// static member means they are created only once and does'nt
// require an object of class for acessing
// void cuz nothing is returned
// calling build context for snackbar and a message to show
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class custom_snack_bar {
  static void showSnackbar(BuildContext context, String msg, String msg1) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Container(
              height: 90,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Error",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const Text(
                          "message",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset('assets/images/bubbles')
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
