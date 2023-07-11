import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_pdf_converter/constants/common_functions.dart';
import 'package:image_to_pdf_converter/constants/constant_ad_ids.dart';
import 'package:image_to_pdf_converter/constants/constants.dart';
import 'package:image_to_pdf_converter/controllers/ads_controller.dart';
import 'package:image_to_pdf_converter/controllers/conversion_controller.dart';
import 'package:image_to_pdf_converter/screens/pdf_viewer/pdf_viewer.dart';
import 'package:path/path.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
 import 'package:uri_to_file/uri_to_file.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenPdfController extends AdsController {
  StreamSubscription? _dataStreamSubscription;
 
  final _sharedText = "".obs;
  Rx<SharedMediaFile> _sharedFile =
      SharedMediaFile("", "", 0, SharedMediaType.FILE).obs;

  String get sharedText => _sharedText.value;
  SharedMediaFile get sharedFile => _sharedFile.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    // Receive text data when app is running
    _dataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String text) {
      onTextReceived(text);
      if (isAppOpenAdReady) {
        showAppOpenAd();
      } else {
        loadAppOpenAd();
      }
    });

    // Receive text data when app is closed
    ReceiveSharingIntent.getInitialText().then((String? text) {
      if (text != null) {
        CommonFunctions().showMyToast("Please wait...");
      }

      onTextReceived(text);
    });

    // Receive files when app is running
    _dataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> files) {
      onFileReceived(files);
      if (isAppOpenAdReady) {
        showAppOpenAd();
      } else {
        loadAppOpenAd();
      }
    });

    // Receive files when app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
         if (files.isNotEmpty) {
        CommonFunctions().showMyToast("Please wait...");
      }
      onFileReceived(files);
    });
  }

  void onTextReceived(String? text) async {
    if (text != null) {
      _sharedText.value = (await toFile(text)).path;
      //please wait
    }

    redirectToPdfViewer(false);
  }

  void onFileReceived(List<SharedMediaFile>? files) {
    if (files != null && files.isNotEmpty) {
      _sharedFile.value = files[0];
      redirectToPdfViewer(true);
    }
  }

  void redirectToPdfViewer(bool isSharedFile) {
    if (isSharedFile == true && _sharedFile.value.path == "") {
      return;
    } else if (isSharedFile == false && _sharedText.value == "") {
      return;
    }
    void openPdf() {
 
      Navigator.of(Get.context!).push(
        MaterialPageRoute(
          builder: (context) => PDFViewer(
            disableShareButtons: true,
             pdfFile: PlatformFile(
              name: isSharedFile
                  ? basenameWithoutExtension(_sharedFile.value.path)
                  : basenameWithoutExtension(_sharedText.value),
              size: isSharedFile
                  ? File(_sharedFile.value.path).lengthSync()
                  : File(_sharedText.value).lengthSync(),
              path: isSharedFile ? _sharedFile.value.path : _sharedText.value,
            ),
          ),
        ),
      );
    }

    openPdf();

    //  Get.to(PDFViewer(
    //   pdfViewerController: _pdfViewerController.value,
    //   pdfFile: PlatformFile(
    //     name: isSharedFile
    //         ? basenameWithoutExtension(_sharedFile.value.path)
    //         : basenameWithoutExtension(_sharedText.value),
    //     size: isSharedFile
    //         ? File(_sharedFile.value.path).lengthSync()
    //         : File(_sharedText.value).lengthSync(),
    //     path: isSharedFile ? _sharedFile.value.path : _sharedText.value,
    //   ),
    // ));
  }
}
