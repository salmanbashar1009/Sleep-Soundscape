import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model_view/feedback_provider.dart';

class EmojiScrollSelector extends StatefulWidget {
  @override
  _EmojiScrollSelectorState createState() => _EmojiScrollSelectorState();
}

class _EmojiScrollSelectorState extends State<EmojiScrollSelector> {
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedbackProvider>(context, listen: false).resetAllValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbackProvider = Provider.of<FeedbackProvider>(context);

    return SizedBox(
      height: 117.h,
      child: ListView.builder(
        controller: feedbackProvider.scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: feedbackProvider.emojiNames.length,
        itemBuilder: (context, index) {
          bool isSelected = feedbackProvider.selectedIndex == index;
          double size = feedbackProvider.getEmojiSize(index);

          String folder = isSelected ? "selected_emojis" : "unselected_emojis";
          String emojiPath = "assets/emojis/feedback_emojis/$folder/${feedbackProvider.emojiNames[index]}";

          return GestureDetector(
            onTap: () => feedbackProvider.selectEmoji(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              width: size,
              height: size,
              child: Image.asset(
                emojiPath,
                width: size,
                height: size,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
