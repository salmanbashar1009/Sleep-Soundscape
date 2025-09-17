import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';

import '../../../model_view/delete_user_provider.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
    required this.imagePath,
    required this.title,
  });

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final darkTheme = context.watch<ThemeProvider>().isDarkMode;

    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 32.w,
      leading: GestureDetector(
        onTap: () {
          context.read<DeleteUserProvider>().cleanError();
          Navigator.pop(context);
        },
        child: ImageIcon(
          AssetImage(imagePath),
          size: 32.r,
          color: darkTheme ? Colors.white : Colors.black,
        ),
      ),
      centerTitle: true,
      title: Text(title),
      titleTextStyle: AppBarTheme.of(context).titleTextStyle,
    );
  }
}
