import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../model_view/feedback_provider.dart';

class StarRatingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final starProvider = Provider.of<FeedbackProvider>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => starProvider.updateStars(index + 1),
          child: Icon(
            Icons.star,
            size: 48.h,
            color: index < starProvider.selectedStars ? Color(0xFFFAD051) : Colors.grey,
          ),
        );
      }),
    );
  }
}
