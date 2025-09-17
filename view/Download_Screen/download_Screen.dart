import 'package:flutter/material.dart';
import 'package:sleep_soundscape/view/Download_Screen/widget/downloadSheet.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                DownloadSheet(context: context);
              },
              child: Center(child: Text('tap tap')),
            ),
          ],
        ),
      );
  }
}
