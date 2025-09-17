import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';

// ignore: must_be_immutable
class SettingsItemTile extends StatelessWidget {
  SettingsItemTile({
    super.key, required this.imagePath, required this.onTap, required this.title,
  });

  final String imagePath;
  final String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {

    final darkTheme = context.watch<ThemeProvider>().isDarkMode;

   


    // return GestureDetector(
    //   onTap: onTap,
    //   child: Row(
    //     children: [
    //       ImageIcon(AssetImage(imagePath),color: darkTheme ? Colors.white : Colors.black,size: 24.r,),
    //       SizedBox(width: 18.w),
    //       Text(title,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //           // color: Colors.white,
    //           fontWeight: FontWeight.w300
    //       ),)
    //     ],
    //   ),
    // );

    return ListTile(
      onTap: onTap,
      leading:  ImageIcon(AssetImage(imagePath),color: darkTheme ? Colors.white : Colors.black,size: 24.r,),
      title:     
            Text(title,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              // color: Colors.white,
              fontWeight: FontWeight.w300
          ),),
          
    );
    
  }
}
