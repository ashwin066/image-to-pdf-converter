import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_pdf_converter/controllers/conversion_controller.dart';
import 'package:image_to_pdf_converter/controllers/open_pdf_controller.dart';
import 'package:image_to_pdf_converter/screens/home/home.dart';
import 'package:image_to_pdf_converter/styles.dart';
import 'package:get/get.dart';

import 'constants/common_functions.dart';

void main() async {
 
  CommonFunctions().deleteTempFilesOnStartup();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ConversionController myController =
      ConversionController(); // Create an instance of the controller

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image to PDF Converter',
      themeMode: ThemeMode.system,
      darkTheme: Styles.themeData(true, context),
      theme: Styles.themeData(false, context),
      home: GetBuilder(
        init: myController,
        builder: (controller) => const Home(),
      ),
    );
  }
}
