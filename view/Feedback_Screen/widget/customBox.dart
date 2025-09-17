import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model_view/theme_provider.dart';

class Custombox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  Custombox({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFFAD051)
              : darkTheme
              ? Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? Color(0xFFFAD051)
                : darkTheme
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.black
                : darkTheme
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
