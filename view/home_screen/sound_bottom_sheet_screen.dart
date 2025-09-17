import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/home_screen_provider.dart';
import 'package:sleep_soundscape/model_view/sound_screen_provider.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/inputDecoration.dart';
import '../../model_view/theme_provider.dart';

void soundBottomSheet(BuildContext context) {
  final darkTheme = context.read<ThemeProvider>().isDarkMode;
  ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Close Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ImageIcon(
                AssetImage("assets/icons/back.png"),
                color: darkTheme ? Colors.white : Colors.black,
                size: 32.r,
              ),
            ),
            SizedBox(height: 32.h),

            /// Search Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: TextFormField(
                onChanged: (value) {
                  context.read<SoundScreenProvider>().musicSearch(value);
                },
                decoration: inputDecoration(
                  context: context,
                  hintText: "Search",
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 12.h),

            /// Categories List
            ValueListenableBuilder<int>(
              valueListenable: selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return SizedBox(
                  height: 40.h,
                  child: Consumer<SoundScreenProvider>(
                    builder: (_, soundScreenProvider, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: soundScreenProvider.categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () async {
                              selectedIndexNotifier.value = index;
                              await soundScreenProvider.fetchMusics(
                                soundScreenProvider.categories[index],
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  color:
                                      isSelected
                                          ? Color(0xffFAD051)
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  soundScreenProvider.categories[index],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w400
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),

            /// Sound List
            Expanded(
              child: Consumer<SoundScreenProvider>(
                builder: (context, soundScreenProvider, child) {
                  if (soundScreenProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (soundScreenProvider.soundList.isEmpty) {
                    return Center(child: Text("No musics available"));
                  }

                  return ListView.builder(
                    itemCount: soundScreenProvider.soundList.length,
                    itemBuilder: (context, index) {
                      final music = soundScreenProvider.soundList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 8.w,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ListTile(
                            onTap: () {
                              context.read<HomeScreenProvider>().setMusicToPlay(
                                music.audioPath!,
                              );
                              context
                                  .read<HomeScreenProvider>()
                                  .togglePlayPause(
                                    togglePlayPauseWithNewMusic: true,
                                  );
                              Navigator.pop(context);
                            },
                            leading:
                                music.imagePath != null &&
                                        music.imagePath!.isNotEmpty
                                    ? Image.network(
                                      music.imagePath!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/images/calm.png', // Fallback if network image fails
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      'assets/images/calm.png', // Default asset image
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),

                            title: Text(
                              music.title ?? 'N/A',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            subtitle: Text(
                              music.subtitle ?? 'N/A',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () async {
                                await soundScreenProvider.playMusic(index);
                                debugPrint(
                                  "\n${soundScreenProvider.playedMusic} numb index pressed \n",
                                );
                              },
                              child:
                                  soundScreenProvider.playedMusic == index
                                      ? Image.asset(
                                        "assets/icons/play2.png",
                                        height: 30,
                                      ) // Pause icon
                                      : Image.asset(
                                        "assets/icons/play1.png",
                                        height: 30,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                      ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
