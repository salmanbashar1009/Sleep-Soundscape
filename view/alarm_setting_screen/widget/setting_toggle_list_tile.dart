import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../global_widget/switch_button.dart';
import '../../../model_view/sound_setting_provider.dart';

Widget buildSwitchRow(
    BuildContext context,
    String label,
    bool switchValue,
    Function() onToggle,
    ) {
  return Consumer<SoundSettingProvider>(
    builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14.sp,
              color:label == "Autoplay sounds while sleeping" ? Theme.of(context).colorScheme.onSecondary : null,
              fontWeight: FontWeight.w400,
            ),
          ),
          SwitchButton(
            isSwitchOn: switchValue,
            onChange: (bool newValue) => onToggle(),
          ),
        ],
      );
    },
  );
}