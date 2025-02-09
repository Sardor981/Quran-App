import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/core/common/injections.dart';
import 'package:quran_app/core/common/utils/app_colors.dart';
import 'package:quran_app/core/common/utils/app_images.dart';
import 'package:quran_app/features/home/presentation/controller/provider/home_provider.dart';
import 'package:quran_app/features/home/presentation/widgets/text_widget.dart';

class SurahDetailsScreen extends StatefulWidget {
  final int surahId;
  const SurahDetailsScreen({super.key, required this.surahId});

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  final player = AudioPlayer();
  int? playingIndex;

  @override
  void initState() {
    super.initState();
    final homeProvider = getIt<HomeProvider>()
      ..getSurahDetails(surahId: widget.surahId);

    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() {
          playingIndex = null;
        });
      }
    });
  }

  void playAyahAudio(String audioUrl, int index) async {
    if (playingIndex == index) {
      await player.pause();
      setState(() {
        playingIndex = null;
      });
    } else {
      await player.stop();
      await player.play(UrlSource(audioUrl));
      setState(() {
        playingIndex = index;
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 45.h,
          backgroundColor: Color.fromARGB(255, 96, 24, 220),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                ZoomDrawer.of(context)?.toggle();
              },
              child: Image.asset(
                AppImages.mainIcon_image,
                width: 35.w,
                height: 35.h,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                AppImages.avatar_img,
                width: 35.w,
                height: 35.h,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5F27EC),
                Color(0xFF10208B),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                    if (homeProvider.isloading) {
                      return Expanded(
                        child: Center(
                          child: Image.asset(
                            AppImages.home_quran_image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    if (homeProvider.allSurahDetails == null) {
                      return CupertinoActivityIndicator();
                    }
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              AppImages.surah_detail_quran,
                              width: MediaQuery.of(context).size.width * 0.40,
                              fit: BoxFit.contain,
                            ),
                            Expanded(
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      homeProvider.allSurahDetails!.data!.name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                    ),
                                    TextWidget(
                                      text: homeProvider
                                          .allSurahDetails!.data!.englishName
                                          .toString(),
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          text: homeProvider.allSurahDetails!
                                              .data!.revelationType
                                              .toString(),
                                          fontSize: 12,
                                          textAlign: TextAlign.center,
                                        ),
                                        TextWidget(
                                          text:
                                              " •${homeProvider.allSurahDetails!.data!.numberOfAyahs} AYAT",
                                          fontSize: 12,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                    if (homeProvider.isloading) {
                      Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (homeProvider.allSurahDetails?.data == null ||
                        homeProvider.allAyahsTranslate?.data == null) {
                      Center(
                        child: TextWidget(
                            text: "Malumot Topilmadi", fontSize: 16.sp),
                      );
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homeProvider
                              .allSurahDetails?.data?.numberOfAyahs
                              ?.toInt() ??
                          0,
                      itemBuilder: (context, index) {
                        final ayah =
                            homeProvider.allSurahDetails?.data?.ayahs?[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:
                                          Colors.transparent.withOpacity(0.3)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.main_cyan_color,
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextWidget(
                                                text: "${index + 1}",
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.share_outlined,
                                                    color: AppColors
                                                        .main_cyan_color,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    playAyahAudio(
                                                        ayah?.audio ??
                                                            "default_audio_url",
                                                        index);
                                                  },
                                                  icon: Icon(
                                                    playingIndex == index
                                                        ? Icons.pause
                                                        : Icons
                                                            .play_arrow_outlined,
                                                    color: AppColors
                                                        .main_cyan_color,
                                                  )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.bookmark_outline,
                                                    color: AppColors
                                                        .main_cyan_color,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //sura arabcada
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Text(
                                          homeProvider.allSurahDetails!.data!
                                              .ayahs![index].text
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 100,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      // TextWidget(
                                      //   text: homeProvider.allAyahsTranslate!
                                      //       .data!.surahs![2].ayahs![2].text
                                      //       .toString(),
                                      //   fontSize: 16.sp,
                                      //   textAlign: TextAlign.left,
                                      //   letterSpacing: 2,
                                      //   maxLines: 3,
                                      // ),
                                      Divider(
                                        thickness: 0,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ); //tugashi
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
