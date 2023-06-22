import 'package:custom_video/customPlayer/controller/custome_video_controller.dart';
import 'package:custom_video/landscapeVideo/controller/landscape_controller.dart';
import 'package:custom_video/landscapeVideo/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LandscapeVideo extends StatelessWidget {
  LandscapeVideo({Key? key}) : super(key: key);
  CustomController controller = Get.find<CustomController>();
  LandscapeController _controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (!_controller.lock.value) {
            controller.isVisible.value = !controller.isVisible.value;
            Future.delayed(const Duration(seconds: 5), () {
              controller.isVisible.value = false;
            });
          }
        },
        child: Stack(
          children: [
            VideoPlayer(controller.controller), //Video Player
            Obx(
              () => controller.caption.isNotEmpty
                  ? ClosedCaption(
                      text: controller.currentSubtitle?.data,
                      textStyle: TextStyle(
                        fontSize: 15.w,
                        color: Colors.white,
                      ),
                    )
                  : SizedBox.shrink(),
            ), //Captions
            Visibility(
              visible: controller.isVisible.value,
              // visible: true,
              child: Container(
                decoration: const BoxDecoration(color: Colors.black45),
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      left: 2.w,
                      top: 2.w,
                      child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: SvgPicture.asset("assets/left.svg")),
                    ),
                    Positioned(
                        left: 30.w,
                        top: 7.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ep 1 - Lorem ipsum dummy text",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8.w),
                            ),
                            const Text(
                              "50 shades of grey",
                              style: TextStyle(color: Colors.white54),
                            )
                          ],
                        )),
                    Container(
                      padding:
                          EdgeInsets.only(top: 60.w, left: 100.w, right: 100.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: SvgPicture.asset(
                              "assets/reverse.svg",
                              width: 15.w,
                              height: 15.w,
                            ),
                            onPressed: () {
                              controller.controller.seekTo(
                                  controller.controller.value.position -
                                      const Duration(seconds: 10));
                            },
                          ),
                          TextButton(
                            child: SvgPicture.asset(
                              controller.isPlaying.value
                                  ? "assets/pause.svg"
                                  : "assets/play.svg",
                              width: 25.w,
                              height: 25.w,
                            ),
                            onPressed: () {
                              controller.isPlaying.value =
                                  !controller.isPlaying.value;
                              controller.controller.value.isPlaying
                                  ? controller.controller.pause()
                                  : controller.controller.play();
                            },
                          ),
                          TextButton(
                            child: SvgPicture.asset(
                              "assets/forward.svg",
                              width: 15.w,
                              height: 15.w,
                            ),
                            onPressed: () {
                              controller.controller.seekTo(
                                  controller.controller.value.position +
                                      const Duration(seconds: 10));
                            },
                          ),
                        ],
                      ),
                    ), //Controls
                    Obx(
                      () => Container(
                        padding: EdgeInsets.only(top: 100.w),
                        // height: 100.h,
                        width: double.infinity,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 30.w, bottom: 30.w, left: 20.w, right: 18.w),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 1.w,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 3.w),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 4.w),
                              thumbColor: Colors.red,
                              activeTrackColor: Colors.red,
                              inactiveTrackColor: Colors.grey,
                              showValueIndicator: ShowValueIndicator.always,
                            ),
                            child: Slider(
                              label: controller
                                  .formatDuration(controller.position.value),
                              value: controller.position.value.inSeconds
                                  .toDouble(),
                              min: 0.0,
                              max: controller.duration.value.inSeconds
                                  .toDouble(),
                              // divisions: duration.value.inSeconds.round(),
                              onChanged: (double newValue) {
                                // position.value =
                                // Duration(seconds: newValue.toInt());
                                controller.controller.seekTo(
                                    Duration(seconds: newValue.toInt()));
                              },
                              mouseCursor: MouseCursor.defer,
                            ),
                          ),
                        ), //Progress Bar
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            top: 140.w, left: 25.w, right: 25.w),
                        //Duration
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: controller
                                    .formatDuration(controller.position.value),
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Text(
                              controller
                                  .formatDuration(controller.duration.value),
                              style: const TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        )),
                    //Bottom Bar Settings and Full Screen
                    Positioned(
                        top: 2.h,
                        right: 10.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                _controller.lock.value =
                                    !_controller.lock.value;
                              },
                              style: TextButton.styleFrom(
                                fixedSize: Size(25.w, 25.w),
                                minimumSize: Size(25.w, 25.w),
                                maximumSize: Size(25.w, 25.w),
                              ),
                              child: SvgPicture.asset(
                                "assets/lock.svg",
                                width: 20.w,
                                height: 20.w,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: TextButton.styleFrom(
                                fixedSize: Size(25.w, 25.w),
                                minimumSize: Size(25.w, 25.w),
                                maximumSize: Size(25.w, 25.w),
                              ),
                              child: SvgPicture.asset(
                                "assets/minimize.svg",
                                width: 15.w,
                                height: 15.w,
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                        bottom: 16,
                        right: 48.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                getBottomSheet(0);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/quality.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    "Quality",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.w,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            GestureDetector(
                              onTap: () => getBottomSheet(1),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/playback.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    "Playback Speed",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.w,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            GestureDetector(
                              onTap: () => getBottomSheet(2),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/subtitles.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    "Subtitles",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.w,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/play1.svg"),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  "Next Video",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.w,
                                  ),
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _controller.lock.value,
              child: Positioned(
                top: 2.h,
                right: 35.w,
                child: TextButton(
                  onPressed: () {
                    _controller.lock.value = !_controller.lock.value;
                    controller.isVisible.value = false;
                  },
                  style: TextButton.styleFrom(
                      fixedSize: Size(25.w, 25.w),
                      minimumSize: Size(25.w, 25.w),
                      maximumSize: Size(25.w, 25.w),
                      backgroundColor: Colors.black54),
                  child: SvgPicture.asset(
                    "assets/minus.svg",
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getBottomSheet(int num) {
    controller.tabController.index = num;
    Get.bottomSheet(
      // backgroundColor: Colors.black,
      // title: "Settings",
      // titleStyle: TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight.w400),
      // content:
      Container(
        padding: EdgeInsets.only(left: 200.h, right: 200.h),
        height: double.infinity,
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.h),
                  topRight: Radius.circular(20.h)),
              color: Colors.black),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Settings",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.w),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ],
            ),
            SizedBox(
              height: 2.w,
            ),
            TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 8.w),
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  text: "Quality",
                ),
                Tab(
                  text: "Playback Speed",
                ),
                Tab(
                  text: "Subtitle",
                ),
              ],
              controller: controller.tabController,
            ),
            SizedBox(
              height: 150.h,
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text("Full HD upto 1080p",
                                style: TextStyle(color: Colors.white))),
                        TextButton(
                            onPressed: () {},
                            child: const Text("HD upto 720p",
                                style: TextStyle(color: Colors.white))),
                        TextButton(
                            onPressed: () {},
                            child: const Text("HD upto 480p",
                                style: TextStyle(color: Colors.white))),
                        TextButton(
                            onPressed: () {},
                            child: const Text("Low Data Saver",
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
                  Obx(
                    () => SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                controller.controller.setPlaybackSpeed(0.25);
                                controller.playback.value = 1;
                              },
                              child: Text(
                                "0.25x",
                                style: TextStyle(
                                    fontSize: 8.w,
                                    color: controller.playback.value == 1
                                        ? const Color(0xffC02739)
                                        : Colors.white),
                              )),
                          TextButton(
                              onPressed: () {
                                controller.playback.value = 2;
                                controller.controller.setPlaybackSpeed(0.5);
                              },
                              child: Text("0.5x",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 2
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () {
                                controller.playback.value = 3;
                                controller.controller.setPlaybackSpeed(0.75);
                              },
                              child: Text("0.75x",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 3
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () {
                                controller.playback.value = 4;
                                controller.controller.setPlaybackSpeed(1);
                              },
                              child: Text("Normal",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 4
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () {
                                controller.controller.setPlaybackSpeed(1.25);
                                controller.playback.value = 5;
                              },
                              child: Text("1.25x",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 5
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () {
                                controller.playback.value = 6;
                                controller.controller.setPlaybackSpeed(1.5);
                              },
                              child: Text("1.5x",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 6
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () {
                                controller.playback.value = 7;
                                controller.controller.setPlaybackSpeed(1.75);
                              },
                              child: Text("1.75x",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 7
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () {
                                controller.playback.value = 8;
                                controller.controller.setPlaybackSpeed(2);
                              },
                              child: Text("2x",
                                  style: TextStyle(
                                      fontSize: 8.w,
                                      color: controller.playback.value == 8
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        direction: Axis.horizontal,
                        children: [
                          TextButton(
                              onPressed: () {
                                controller.caption.clear();
                                controller.subVal.value = 0;
                              },
                              child: Text("Off",
                                  style: TextStyle(
                                      color: controller.subVal.value == 0
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () async {
                                List srtFile = await controller.getCloseCaptionFile(
                                    "https://www.capitalcaptions.com/wp-content/uploads/2017/04/How-to-Write-.SRT-Subtitles-for-Video.srt");
                                const AsyncSnapshot.waiting();
                                controller.caption.value = srtFile;
                                controller.subVal.value = 1;
                              },
                              child: Text(" English",
                                  style: TextStyle(
                                      color: controller.subVal.value == 1
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                          TextButton(
                              onPressed: () async {
                                List srtFile = await controller.getCloseCaptionFile(
                                    "https://www.opensubtitles.com/download/0FA942092B1481920346D1129A8032CB73A6F88F67FD9D992A972315AE7ECAB837966AD79EE0D4953CFAB836FA4853623D4720E6FACF4A9B8DE3FA61F8E28FACA49513E2ED2EF0463560DF984095B5A95230973DED740BAA4FBD54CB39920527A0075D5E10426FB668F598A7FBD6C82382B54CF205BA222FFBA48C2498FBABAC1DE250E823D4E28E13925C097C752BB91435E9F92295EB6B46C97FDFC44C55788003C3AF9749C24505BEFFF51DAE16073664DD461A273E7CE7CA698FB3AB61982A440E87A5BD29D6AD3298EEEBC0E5143B0531643028194B6451C9D29123EB795387F0CB9770204D78E06760ED0F11D04EAB5838E79B28EC956564DE49639DE56D72CFE22A469AA5B94D2159DC2D6C928F96071E6D0CE87F76F10437AB0F5F78/subfile/Egoist.2023.1080p.U-NEXT.WEB-DL.X264-XRES.otoka_sub-018-chi_sim.en.srt");
                                const AsyncSnapshot.waiting();
                                controller.caption.value = srtFile;
                                controller.subVal.value = 2;
                              },
                              child: Text("Hindi",
                                  style: TextStyle(
                                      color: controller.subVal.value == 2
                                          ? const Color(0xffC02739)
                                          : Colors.white))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
