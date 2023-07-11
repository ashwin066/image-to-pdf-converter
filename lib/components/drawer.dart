import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_to_pdf_converter/screens/list_saved_pdf/list_saved_pdf.dart';
import 'package:image_to_pdf_converter/screens/pdf_viewer/pdf_viewer.dart';
import 'package:image_to_pdf_converter/size_config.dart';
import 'package:share_plus/share_plus.dart';
 import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/common_functions.dart';
import '../constants/constants.dart';
import 'main_list_tile.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final titles = const <String>[
    "Open a PDF",
    "Saved PDFs",
    "Rate us",
    "Share this app",
    "Contact us",
    "Privacy policy",
  ];
  final icons = const <IconData>[
    Icons.file_open_rounded,
    Icons.picture_as_pdf_rounded,
    Icons.star_rounded,
    Icons.share_rounded,
    Icons.mail_rounded,
    Icons.privacy_tip_rounded,
  ];
  String appVersion = "";
   @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

  loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
     });
  }

  bool loadingShare = false;
  @override
  Widget build(BuildContext context) {
    final onPress = <Function()?>[
      () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          Get.to(PDFViewer(
            pdfFile: result.files.first,
           ));
        } else {
          // User canceled the picker
        }
      },
      () {
        Get.back();
        Get.to(const ListSavedPdf());
      },
      () {
        CommonFunctions().rateUs(context, true);
      },
      () async {
        if (loadingShare == false) {
          loadingShare = true;
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String packageName = packageInfo.packageName;

          await Share.share(
            "Hey! Found this cool app called Image to PDF Converter, PDF Viewer that lets you effortlessly transform your images into professional-looking PDF documents. You can merge multiple images into a single PDF file. Check it out: https://play.google.com/store/apps/details?id=$packageName",
            subject: "Image to PDF Converter, PDF Viewer",
          );
          loadingShare = false;
        }
      },
      () {
        CommonFunctions()
            .launchMyEmailSubmission(LaunchMode.externalApplication);
      },
      () {
        CommonFunctions().launchMyUrl(
            "https://github.com/ashwin066/Image-To-Pdf-Converter-Privacy-Policy/blob/main/Privacy%20Policy",
            LaunchMode.externalApplication);
      },
    ];
    return Drawer(
        surfaceTintColor: Colors.transparent,
        width: SizeConfig.screenWidth! / 1.5,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth! / 4.7,
                    height: SizeConfig.screenWidth! / 4.7,
                    child:
                    Material(
                      // with Material
                      elevation: 15.0,
                    borderRadius:borderRadius18,
                      clipBehavior: Clip.antiAlias,
                      // with Material
                      child: Image.asset('assets/images/logo.png'),
                    ),  
                  ),
                  SizedBox(
                    width: 0,
                    height: getProportionateScreenHeight(5),
                  ),
                  Text('Image to PDF',
                      style: TextStyle(
                        color: aWhite,
                        fontSize: getProportionateScreenWidth(20),
                      )),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return MainListTile(
                    text: titles[index],
                    icon: icons[index],
                    onPress: onPress[index],
                    iconColor: Theme.of(context).primaryColor,
                  );
                }),
            MainListTile(
              text: "Image to PDF : $appVersion",
              icon: Icons.verified_rounded,
              iconColor: Theme.of(context).primaryColor,
            )
          ],
        ));
  }
}
