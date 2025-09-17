import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../model/sound_scape_model.dart';
import '../../model_view/reminder_screen_provider.dart';
import '../../model_view/sound_setting_provider.dart';
import '../../model_view/theme_provider.dart';

void soundScapeScreen(BuildContext context, String type) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final soundProvider = context.read<SoundSettingProvider>(); //
                     soundProvider.stopMusic();

                    Navigator.pop(context);
                  },
                  child: ImageIcon(
                    AssetImage("assets/icons/back.png"),
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    size: 32.r,
                  ),
                ),
                SizedBox(width: 80.w),
                Text(
                  type == 'music' ? "Soundscape " : "Ringtone",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            type == 'music'
                ? Expanded(
                  child: Consumer<SoundSettingProvider>(
                    builder: (context, soundSettingProvider, child) {
                      if (soundSettingProvider.isLoading &&
                          !soundSettingProvider.isLoadingMore) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (soundSettingProvider.musicList.isEmpty ||
                          soundSettingProvider.musicList.first.sounds == null ||
                          soundSettingProvider
                              .musicList
                              .first
                              .sounds!
                              .isEmpty) {
                        return Center(child: Text("No musics found"));
                      }

                      final List<Sounds> soundsList =
                          soundSettingProvider.musicList.first.sounds!;
                      final ScrollController _scrollController =
                          ScrollController();

                      _scrollController.addListener(() {
                        if (_scrollController.position.pixels ==
                                _scrollController.position.maxScrollExtent &&
                            !soundSettingProvider.isLoadingMore &&
                            soundSettingProvider.hasMore) {
                          soundSettingProvider.allMusics(isLoadMore: true);
                        }
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            soundsList.length +
                            (soundSettingProvider.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == soundsList.length) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final sound = soundsList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                soundSettingProvider.playMusic(index);
                                soundSettingProvider.selectMusic(index);
                                debugPrint("Playing: ${sound.audioPath}");
                                soundSettingProvider.saveAudioPath();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.transparent,

                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  leading:
                                      sound.imagePath != null
                                          ? Image.network(
                                            sound.imagePath!,
                                            width: 40,
                                            height: 40,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Image.asset(
                                                  'assets/images/white_sound.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                          )
                                          : Image.asset(
                                            'assets/images/white_sound.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                  title: Text(
                                    sound.title ?? "N/A",
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // This prevents the row from taking all available space
                                    children: [
                                      (soundSettingProvider.selectedAudioPath ==
                                                  sound.audioPath ||
                                              soundSettingProvider
                                                      .soundSettings
                                                      .soundscapes
                                                      .audioPath ==
                                                  sound.audioPath)
                                          ? Icon(
                                            Icons.check,
                                            color: Color(0xffFAD051),
                                          )
                                          : SizedBox(),
                                      SizedBox(width: 5.w),

                                      soundSettingProvider.playedMusic == index
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
                : Expanded(
                  child: Consumer<SoundSettingProvider>(
                    builder: (context, soundSettingProvider, child) {
                      return ListView.builder(
                        itemCount: soundSettingProvider.ringtones.length,
                        itemBuilder: (context, index) {
                          final sound =
                              soundSettingProvider
                                  .ringtones[index]; // Get the current ringtone

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                debugPrint("Playing: ${sound.path}");
                                soundSettingProvider.playRingTon(index);
                                soundSettingProvider.selectRingTon(index);
                                soundSettingProvider.saveRingTonPath();
                                changeAlarm(assetAlarmPath: sound.path);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  leading:
                                      soundSettingProvider.selectedAudioPath ==
                                              sound.path
                                          ? Icon(
                                            Icons.music_note,
                                            color: Color(0xffFAD051),
                                          ) // Icon if selected
                                          : Image.asset(
                                            'assets/images/white_sound.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                  title: Text(
                                    sound.name,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,

                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),

                                  trailing: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // This prevents the row from taking all available space
                                    children: [
                                      (soundSettingProvider
                                                      .selectedRingTonPath ==
                                                  sound.path ||
                                              soundSettingProvider
                                                      .soundSettings
                                                      .alarm
                                                      .ringtone
                                                      .name ==
                                                  sound.name)
                                          ? Icon(
                                            Icons.check,
                                            color: Color(0xffFAD051),
                                          ) // Show check icon if selected
                                          : SizedBox(),
                                      SizedBox(width: 5.w),
                                      soundSettingProvider.playedRingTon ==
                                              index
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
                                    ],
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
