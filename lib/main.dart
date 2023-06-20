import 'package:custom_video/customPlayer/View/custom_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ScreenUtilInit(builder: (context, child) {
    return GetMaterialApp(
      home: CustomPlayer(),
    );
  }));
}
