import 'package:custom_video/customPlayer/controller/custome_video_controller.dart';
import 'package:custom_video/landscapeVideo/View/landscape_player.dart';
import 'package:custom_video/landscapeVideo/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

class PotraitPlayer extends StatelessWidget {
  PotraitPlayer({super.key});
  CustomController controller = Get.put(CustomController());
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.isVisible.value = !controller.isVisible.value;
            Future.delayed(const Duration(seconds: 5), () {
              controller.isVisible.value = false;
            });
          },
          child: Stack(
            children: [
              VideoPlayer(controller.controller), //Video Player
              Obx(
                () => controller.caption.isNotEmpty
                    ? ClosedCaption(
                        text: controller.currentSubtitle?.data,
                        textStyle:
                            TextStyle(fontSize: 15.w, color: Colors.white),
                      )
                    : SizedBox.shrink(),
              ), //Captions
              Visibility(
                visible: controller.isVisible.value,
                // visible: true,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black45),
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.only(top: 55.w, left: 50.w, right: 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: SvgPicture.asset(
                                "assets/reverse.svg",
                                width: 30.h,
                                height: 30.h,
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
                                width: 30.h,
                                height: 30.h,
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
                          height: 200.h,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 30.w,
                                bottom: 30.w,
                                left: 20.w,
                                right: 18.w),
                            child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 2.w,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 6.w),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 1.w),
                                  thumbColor: Colors.red,
                                  activeTrackColor: Colors.red,
                                  inactiveTrackColor: Colors.grey,
                                  showValueIndicator: ShowValueIndicator.always,
                                  rangeValueIndicatorShape:
                                      PaddleRangeSliderValueIndicatorShape()),
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
                                mouseCursor: MouseCursor.uncontrolled,
                              ),
                            ),
                          ), //Progress Bar
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              top: 160.w, left: 25.w, right: 25.w),
                          //Duration
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: controller.formatDuration(
                                      controller.position.value),
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
                      //Brightness and VOlume Sliders
                      Positioned(
                        bottom: 55.h,
                        left: 20.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: controller.brightVisible.value,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: SizedBox(
                                  width: 80.w,
                                  // margin: EdgeInsets.only(
                                  //     top: 30.w,
                                  //     bottom: 30.w,
                                  //     left: 20.w,
                                  //     right: 18.w),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 2.w,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6.w),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 1.w),
                                        thumbColor: Colors.white,
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.grey),
                                    child: Slider(
                                      value: controller.setBrightness.value,
                                      min: 0.0,
                                      max: 1.0,
                                      // divisions: duration.value.inSeconds.round(),
                                      onChanged: (double newValue) {
                                        // position.value =
                                        // Duration(seconds: newValue.toInt());
                                        controller.setBrightness.value =
                                            newValue;
                                        ScreenBrightness()
                                            .setScreenBrightness(newValue);
                                      },
                                      mouseCursor: MouseCursor.uncontrolled,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: TextButton(
                                onPressed: () {
                                  controller.brightVisible.value =
                                      !controller.brightVisible.value;
                                  Future.delayed(
                                      const Duration(seconds: 5),
                                      () => controller.brightVisible.value =
                                          false);
                                },
                                child: SvgPicture.asset(
                                  "assets/brightness.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 55.h,
                        right: 20.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: controller.volVisible.value,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: SizedBox(
                                  width: 80.w,
                                  // margin: EdgeInsets.only(
                                  //     top: 30.w,
                                  //     bottom: 30.w,
                                  //     left: 20.w,
                                  //     right: 18.w),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 2.w,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6.w),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 1.w),
                                        thumbColor: Colors.white,
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.grey),
                                    child: Slider(
                                      value: controller.setVolumeValue.value,
                                      min: 0.0,
                                      max: 1.0,
                                      // divisions: duration.value.inSeconds.round(),
                                      onChanged: (double newValue) {
                                        // position.value =
                                        // Duration(seconds: newValue.toInt());
                                        controller.setVolumeValue.value =
                                            newValue;
                                        VolumeController().setVolume(newValue);
                                      },
                                      mouseCursor: MouseCursor.uncontrolled,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: TextButton(
                                onPressed: () {
                                  controller.volVisible.value =
                                      !controller.volVisible.value;
                                  Future.delayed(
                                      const Duration(seconds: 5),
                                      () =>
                                          controller.volVisible.value = false);
                                },
                                child: SvgPicture.asset(
                                  "assets/volume.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Bottom Bar Settings and Full Screen
                      Positioned(
                          bottom: -8.w,
                          right: 10.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.bottomSheet(Popup());
                                },
                                style: TextButton.styleFrom(
                                  fixedSize: Size(35.w, 35.w),
                                  minimumSize: Size(35.w, 35.w),
                                  maximumSize: Size(35.w, 35.w),
                                ),
                                child: SvgPicture.asset(
                                  "assets/settings.svg",
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => LandscapePlayer(),
                                      arguments: controller.position.value);
                                },
                                style: TextButton.styleFrom(
                                  fixedSize: Size(35.w, 35.w),
                                  minimumSize: Size(35.w, 35.w),
                                  maximumSize: Size(35.w, 35.w),
                                ),
                                child: SvgPicture.asset(
                                  "assets/fullscreen.svg",
                                  width: 15.w,
                                  height: 15.w,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
