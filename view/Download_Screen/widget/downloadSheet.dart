import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model_view/download_provider.dart';
import '../../../model_view/theme_provider.dart';

void DownloadSheet({required BuildContext context}) {
  final darkTheme =
      Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

  showModalBottomSheet(
    context: context,
    // backgroundColor: Color(0xFF212121),
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
    ),
    builder: (context) {
      final downloadProvider = Provider.of<DownloadProvider>(
        context,
        listen: false,
      );

      ///Fetch sounds when the modal opens
      if (downloadProvider.sounds.isEmpty) {
        downloadProvider.fetchSounds();
      }

      return Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          return Container(
            width: double.infinity,
            height: 730.h,
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                SizedBox(height: 15.h),

                /// Header Row
                Row(
                  children: [
                    /// Back Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          darkTheme ? Colors.white : Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          "assets/icons/back.png",
                          height: 32.h,
                          width: 32.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 80.w),

                    /// Title
                    Text(
                      "Downloads",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        //color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                /// Show loading indicator if fetching data**
                provider.isLoading && provider.sounds.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification.metrics.pixels ==
                                  scrollNotification.metrics.maxScrollExtent &&
                              provider.hasMore &&
                              !provider.isLoading) {
                            provider.fetchSounds();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount:
                              provider.sounds.length +
                              (provider.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            /// **Show Loader if more sounds are available
                            if (index == provider.sounds.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final sound = provider.sounds[index];
                            String fileName =
                                sound.title?.replaceAll(" ", "_") ??
                                "Unknown_Title";
                            String? audioPath = sound.audioPath;
                            String? title = sound.title;

                            return Container(
                              padding: EdgeInsets.all(10.w),
                              margin: EdgeInsets.symmetric(vertical: 6.h),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color:
                                    darkTheme
                                        ? Colors.white.withOpacity(0.04)
                                        : Colors.black.withOpacity(0.04),
                                //  color: Colors.white.withOpacity(0.02),
                                border: Border.all(
                                  //  color: Colors.white.withOpacity(0.08),
                                  color:
                                      darkTheme
                                          ? Colors.white.withOpacity(0.08)
                                          : Colors.black.withOpacity(0.08),
                                  width: 0.8.w,
                                ),
                              ),

                              child: Row(
                                children: [
                                  /// Sound Image with Rounded Corners
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Image.network(
                                      sound.imagePath ??
                                          "assets/icons/default.png",
                                      height: 64.h,
                                      width: 64.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          "assets/icons/default.png",
                                          height: 64.h,
                                          width: 64.w,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.w),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title ?? "Unknown Title",
                                        style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          //color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        sound.subtitle ?? "No description",
                                        style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300,
                                          //color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Spacer(),

                                  ///Download/Progress Button**
                                  provider.downloadProgress.containsKey(
                                        fileName,
                                      )
                                      ? CircularProgressIndicator(
                                        value:
                                            provider
                                                .downloadProgress[fileName]! /
                                            100,
                                        // color: Colors.white,
                                      )
                                      : InkWell(
                                        onTap: () {
                                          if (audioPath != null &&
                                              audioPath.isNotEmpty) {
                                            provider.downloadFile(
                                              audioPath,
                                              title ?? "Unknown Title",
                                            );
                                          } else {
                                            debugPrint(
                                              "No audio path available for this item.",
                                            );
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(50),
                                        //splashColor: Colors.white24,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              provider.downloadProgress
                                                      .containsKey(fileName)
                                                  ? SizedBox(
                                                    width: 32.w,
                                                    height: 32.h,
                                                    child: CircularProgressIndicator(
                                                      value:
                                                          provider
                                                              .downloadProgress[fileName]! /
                                                          100,
                                                      //  color: Colors.white,
                                                      strokeWidth: 2.w,
                                                    ),
                                                  )
                                                  : InkWell(
                                                    onTap: () {
                                                      if (audioPath != null &&
                                                          audioPath
                                                              .isNotEmpty) {
                                                        provider.downloadFile(
                                                          audioPath,
                                                          title ??
                                                              "Unknown Title",
                                                        );
                                                      } else {
                                                        debugPrint(
                                                          "No audio path available for this item.",
                                                        );
                                                      }
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                    splashColor:
                                                        darkTheme
                                                            ? Colors.white24
                                                            : Colors.black26,

                                                    child: Container(
                                                      width: 32.w,
                                                      height: 32.h,
                                                      padding: EdgeInsets.all(
                                                        7.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              50,
                                                            ),
                                                        border: Border.all(
                                                          //  color: Colors.white.withOpacity(0.08),
                                                          color:
                                                              darkTheme
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                        0.08,
                                                                      )
                                                                  : Colors.black
                                                                      .withOpacity(
                                                                        0.08,
                                                                      ),
                                                          width: 0.8.w,
                                                        ),
                                                        //color: darkTheme ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                                                      ),
                                                      child: Image.asset(
                                                        'assets/icons/download.png',
                                                        width: 16.w,
                                                        height: 16.h,
                                                        fit: BoxFit.contain,
                                                        color:
                                                            darkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                /// Loading Indicator when Fetching More Data
                if (provider.isLoading && provider.sounds.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(10.h),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
