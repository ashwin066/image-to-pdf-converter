import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/rate_us_box.dart';
import '../size_config.dart';
import 'constants.dart';

class CommonFunctions {
  Future<String> getStorageDirectory(bool returnParentPath) async {
    if (Platform.isAndroid) {
      final directory =
          await getExternalStorageDirectory(); // OR return "/storage/emulated/0/Download";

      if (returnParentPath == true) {
        var parent = directory?.parent;
        while (parent != null && parent.path != '/storage/emulated/0') {
          parent = parent.parent;
        }

        return parent?.path ?? '/storage/emulated/0';
      } else {
        return directory!.path;
      }
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  Future<bool>? isFileAlreadySaved(
    String filePath,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final String? result = await prefs.getString(filePath);

    if (result == null) {
      return false;
    } else {
      return true;
    }
  }

  // Future<bool> saveFile(
  //   BuildContext context,
  //   String filePath,
  //   bool? isImage,
  //   String ext,
  // ) async {
  //   PermissionStatus isPermitted = await Permission.storage.request();
  //   String pathUpload = await getStorageDirectory(false);
  //   final String rfileName = filePath.split('/').last;

  //   String fileName2 = '${pathUpload}/' + rfileName;
  //   bool? isAlreadySaved = await isFileAlreadySaved(
  //     fileName2,
  //   );
  //   if (isAlreadySaved != true) {
  //     if (PermissionStatus.granted == isPermitted) {
  //       final prefs2 = await SharedPreferences.getInstance();

  //       final file = File(filePath);

  //       await file.copy(fileName2);
  //       // prefs2.setString(filePath, fileName2);
  //       await ImageGallerySaver.saveFile(filePath, name: rfileName);
  //       CommonWidgets().rateUs(context, false);
  //       await prefs2.setString(fileName2, rfileName);

  //       Fluttertoast.showToast(
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.TOP,
  //           msg: "${isImage == true ? "Image Saved" : "Video Saved"}",
  //           textColor: aWhite,
  //           backgroundColor: TealGreen);
  //       logEvent(
  //         name: "${isImage == true ? "image_saved" : "video_saved"}",
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.TOP,
  //         msg: "Already Saved",
  //         textColor: aWhite,
  //         backgroundColor: TealGreen);
  //     logEvent(
  //       name: "${isImage == true ? "image" : "video"}_already_saved",
  //     );
  //   }
  //   a() {
  //     Provider.of<GetStatusProvider>(context, listen: false)
  //         .getStatus("", true,true);
  //   }

  //   a();
  //   return Future.delayed(defaultDuration0sec, () {
  //     return true;
  //   });
  // }

  // void logEvent({
  //   String? name,
  //   Map<String, Object?>? parameters,
  // }) {
  //   FirebaseAnalytics.instance
  //       .logEvent(name: name ?? "empty", parameters: parameters);
  // }

  // Future<bool> deleteFile(
  //     BuildContext context, String filePath, String pathType) async {
  //   final file = File(filePath);
  //   FileSystemEntity result = await file.delete();
  //   bool check = await result.exists();
  //   back() {
  //     Navigator.pop(context);
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   final String? fileName = prefs.getString(filePath);
  //   if (fileName != null) {
  //     prefs.remove(filePath);

  //     back();
  //   }
  //   String? toDelete = "$pathType" + "/" + "$fileName";

  //   done() {
  //     Fluttertoast.showToast(
  //             msg: 'Deleted Successfully',
  //             textColor: aWhite,
  //             toastLength: Toast.LENGTH_LONG,
  //             gravity: ToastGravity.CENTER,
  //             backgroundColor: TealGreen)
  //         .then((value) {
  //       Provider.of<GetStatusProvider>(context, listen: false)
  //           .getStatus("", false, true);
  //       back();
  //     });
  //   }

  //   final realFile = File(toDelete);
  //   if (await realFile.exists()) {
  //     await realFile.delete(recursive: true).catchError((d) => done());
  //     done();
  //   } else {
  //     done();
  //   }

  //   return !check;
  // }

  rateUs(BuildContext context, bool? strictShowDialog) async {
    final prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('reviewed');
    if (strictShowDialog == true) {
      showDialog(context: context, builder: (context) => RateUsBox());
    } else {
      if (action != null) {
        if (action == "store") {
        } else if (action == "mail") {
          //    showDialog(context: context, builder: (context) => RateUsBox());
        }
      } else {
        showDialog(context: context, builder: (context) => RateUsBox());
      }
    }
  }

  Future<void> launchMyUrl(url, LaunchMode launchMode) async {
    if (!await launchUrl(Uri.parse(url), mode: launchMode)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchStoreForRating() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    CommonFunctions().launchMyUrl(
        "https://play.google.com/store/apps/details?id=$packageName",
        LaunchMode.externalApplication);
  }

  void launchMyEmailSubmission(LaunchMode launchMode) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'nullspotapps@gmail.com',
    );
    String url = params.toString();
    if (!await launchUrl(Uri.parse(url), mode: launchMode)) {
      throw 'Could not launch $url';
    }
  }

  // Future<bool> isPersistedUri(AppType appType) async {
  //   bool isPersisted = await shared_storage.isPersistedUri(
  //       appType == AppType.whatsapp
  //           ? AppConstants.whatsappUri
  //           : AppConstants.whatsappBusinessUri);
  //   return isPersisted;
  // }

  bool? verifyPackageNameExists(
      List<Map<String, String>> allInstalledApps, String packageName) {
    final appMap = allInstalledApps
        .where((map) => map['package_name'] == packageName)
        .isNotEmpty;

    return appMap;
  }

  Future<bool> checkPremiumWithSP() async {
    final prefs = await SharedPreferences.getInstance();

    final bool? premium = prefs.getBool('isPremiumUser');

    return premium ?? false;
  }

  void deleteTempFilesOnStartup() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.listSync(recursive: true).forEach((entity) {
          if (entity is File) {
            entity.deleteSync();
          }
        });
      }
      deleteAllFilesByUriToFile();
      print("Temp files deleted");
    } catch (e) {
      print('Error deleting temp files: $e');
    }
  }

  void showMyToast(String? msg){
        Fluttertoast.showToast(
        msg: msg??"Please wait...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: PrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void deleteAllFilesByUriToFile() async {
    String? appDir = (await getApplicationDocumentsDirectory()).path;
    final deleteFilesInDirectory =
        Directory(appDir.replaceAll('app_flutter', 'files') + '/uri_to_file');
    if (deleteFilesInDirectory.existsSync()) {
      deleteFilesInDirectory.listSync().forEach((file) {
        if (file is File) {
          file.deleteSync();
        }
      });
    }
  }

  Future<dynamic> MyAlertDialog(
      {required BuildContext context,
      required String title,
      required String content,
      IconData? icon,
      Color? iconColor,
      List<Widget>? actions}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            icon: Icon(icon ?? Icons.verified_rounded,
                size: 55, color: iconColor ?? Colors.green),
            insetPadding: paddingMarginAll20,
            title: Text(title),
            content: SizedBox(
              width: double.infinity,
              child: Text(
                content,
                textAlign: TextAlign.center,
              ),
            ),
            titleTextStyle: Theme.of(context).textTheme.headlineMedium,
            iconPadding: paddingMarginTLR15,
            contentTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: DarkGray),
            titlePadding: paddingMarginAll20.copyWith(bottom: 8, top: 8),
            contentPadding: paddingMarginLR15,
            actionsPadding: paddingMarginAll8,
            actionsAlignment: MainAxisAlignment.center,
            actions: actions);
        ;
      },
    );
  }
}
