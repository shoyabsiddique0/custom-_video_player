import 'package:custom_video/customPlayer/controller/custome_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Popup extends StatelessWidget {
  Popup({Key? key}) : super(key: key);
  CustomController controller = Get.find<CustomController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 280.h,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.w),
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
          height: 15.w,
        ),
        TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.w),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                          onTap: () {
                            controller.controller.setPlaybackSpeed(0.25);
                            controller.playback.value = 1;
                          },
                          title: Text(
                            "0.25x",
                            style: TextStyle(
                                color: controller.playback.value == 1
                                    ? const Color(0xffC02739)
                                    : Colors.white),
                          )),
                      ListTile(
                          onTap: () {
                            controller.playback.value = 2;
                            controller.controller.setPlaybackSpeed(0.5);
                          },
                          title: Text("0.5x",
                              style: TextStyle(
                                  color: controller.playback.value == 2
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                      ListTile(
                          onTap: () {
                            controller.playback.value = 3;
                            controller.controller.setPlaybackSpeed(0.75);
                          },
                          title: Text("0.75x",
                              style: TextStyle(
                                  color: controller.playback.value == 3
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                      ListTile(
                          onTap: () {
                            controller.playback.value = 4;
                            controller.controller.setPlaybackSpeed(1);
                          },
                          title: Text("Normal",
                              style: TextStyle(
                                  color: controller.playback.value == 4
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                      ListTile(
                          onTap: () {
                            controller.controller.setPlaybackSpeed(1.25);
                            controller.playback.value = 5;
                          },
                          title: Text("1.25x",
                              style: TextStyle(
                                  color: controller.playback.value == 5
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                      ListTile(
                          onTap: () {
                            controller.playback.value = 6;
                            controller.controller.setPlaybackSpeed(1.5);
                          },
                          title: Text("1.5x",
                              style: TextStyle(
                                  color: controller.playback.value == 6
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                      ListTile(
                          onTap: () {
                            controller.playback.value = 7;
                            controller.controller.setPlaybackSpeed(1.75);
                          },
                          title: Text("1.75x",
                              style: TextStyle(
                                  color: controller.playback.value == 7
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                      ListTile(
                          onTap: () {
                            controller.playback.value = 8;
                            controller.controller.setPlaybackSpeed(2);
                          },
                          title: Text("2x",
                              style: TextStyle(
                                  color: controller.playback.value == 8
                                      ? const Color(0xffC02739)
                                      : Colors.white))),
                    ],
                  ),
                ),
              ),
              Obx(
                () => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}
