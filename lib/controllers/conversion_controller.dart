import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_to_pdf_converter/constants/common_functions.dart';
import 'package:image_to_pdf_converter/constants/constants.dart';
import 'package:image_to_pdf_converter/controllers/ads_controller.dart';
import 'package:image_to_pdf_converter/controllers/open_pdf_controller.dart';
import 'package:image_to_pdf_converter/screens/pdf_viewer/pdf_viewer.dart';
import 'package:image_to_pdf_converter/size_config.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:share_plus/share_plus.dart';
 
class ConversionController extends OpenPdfController {
  final _isLoading = false.obs;
  final _isImagesPicked = false.obs;
  final _fileName = TextEditingController(
    text: 'PDF_File',
  ).obs;
  List<PlatformFile> _images = <PlatformFile>[].obs;
  final _needMargin = true.obs;
  final _orientation = pw.PageOrientation.portrait.obs;
  final _pdfPageFormat = PdfPageFormat.a4.obs;
  final _compress_images = true.obs;
  final RxDouble _compress_quality = 60.0.obs;

  final pdf = pw.Document().obs;

  bool get isLoading => _isLoading.value;
  bool get isImagesPicked => _isImagesPicked.value;
  List<PlatformFile> get images => _images;
  TextEditingController get fileName => _fileName.value;
  bool get needMargin => _needMargin.value;
  pw.PageOrientation get orientation => _orientation.value;
  PdfPageFormat get pdfPageFormat => _pdfPageFormat.value;
  bool get compress_images => _compress_images.value;
  double get compress_quality => _compress_quality.value;

  @override
  void onInit() {
    super.onInit();

    _fileName.value = TextEditingController(
      text: generateUniqueFilename(),
    );
  }

  Future<void> pickImages() async {
    _isLoading.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );

    if (result != null) {
      _isImagesPicked.value = true;

      for (PlatformFile image in result.files) {
        _images.add(image);
      }

      print(_images.length);

      // PlatformFile file = result.files.first;
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
    } else {
      // User canceled the picker
    }
    _isLoading.value = false;
  }

  void reArrange(int beforeIndex, int afterIndex) {
    if (beforeIndex < afterIndex) {
      // Item moved downwards, shift items between indices.
      final item = _images.removeAt(beforeIndex);
      _images.insert(afterIndex, item);
    } else if (beforeIndex > afterIndex) {
      // Item moved upwards, shift items between indices.
      final item = _images.removeAt(beforeIndex);
      _images.insert(afterIndex, item);
    }
    // No need to rearrange if beforeIndex and afterIndex are the same.
  }

  void removeImage(int removeAt) {
    HapticFeedback.heavyImpact();
     
     
    _images.removeAt(removeAt);
    if(_images.isEmpty){
      _isImagesPicked.value = false;
    }
  }

  void cropImage(int imageIndex, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _images[imageIndex].path!,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Edit Image',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    _images[imageIndex] = PlatformFile(
      name: basename(croppedFile!.path),
      path: croppedFile.path,
      size: await File(croppedFile.path).length(),
    );
  }

  String generateUniqueFilename() {
    DateTime now = DateTime.now();
    String formattedDateTime =
        '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}_${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';
    String filename = 'PDF_$formattedDateTime';
    return filename;
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  setFileName() {
    _fileName.value = TextEditingController(
      text: generateUniqueFilename(),
    );
  }

  void setNeedMargin(bool value) {
    _needMargin.value = value;
  }

  void setOrientation(pw.PageOrientation value) {
    _orientation.value = value;
  }

  void setPdfPageFormat(PdfPageFormat value) {
    _pdfPageFormat.value = value;
  }

  void setCompressImages(bool value) {
    _compress_images.value = value;
  }

  void setCompressQuality(double value) {
    _compress_quality.value = value;
  }

  void clearAllImages() {
    _isImagesPicked.value = false;
    _images.clear();
  }

  Future<Uint8List?> compressAndGetFile(
    File file,
  ) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: _compress_quality.value.toInt(),
    );

    return result;
  }

  Future<void> createPDF() async {
    _isLoading.value = true;
    try {
      for (var img in _images) {
        final pw.MemoryImage image;
        if (_compress_images.value == true) {
          final Uint8List? compressedFile =
              await compressAndGetFile(File(img.path!));
          print('compressedFile: $compressedFile');
          image = pw.MemoryImage(compressedFile!);
        } else {
          image = pw.MemoryImage(File(img.path!).readAsBytesSync());
        }
        pdf.value.addPage(pw.Page(
            margin: _needMargin.value == true
                ? const pw.EdgeInsets.all(15)
                : pw.EdgeInsets.zero,
            orientation: _orientation.value,
            pageFormat: _pdfPageFormat.value,
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
            }));
      }

      await savePDF();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('😔 Error Saving PDF\nerror code: 2'),
        ),
      );
    }
    _isLoading.value = false;
  }

  Future<void> savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();

      final file = File(
          '${dir?.path}/${basenameWithoutExtension(_fileName.value.text)}.pdf');
      await file.writeAsBytes(await pdf.value.save());

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('🥳 PDF Saved Successfully'),
        ),
      );

      Get.back();
      viewSavedPDF(file);

      CommonFunctions().MyAlertDialog(
        context: Get.context!,
        title: 'PDF Saved Successfully',
        content: 'The conversion was completed\nsuccessfully.',
        actions: [
          TextButton(
            onPressed: () {
              OpenFile.open(file.path);
            },
            child: Text(
              'OPEN WITH',
              style: TextStyle(color: Theme.of(Get.context!).primaryColor),
            ),
          ),
          TextButton(
            child: Text(
              'SHARE',
              style: TextStyle(color: Theme.of(Get.context!).primaryColor),
            ),
            onPressed: () {
              Share.shareFiles(
                [file.path],
                text: 'PDF file',
                subject: 'PDF file',
              );
            },
          ),
          TextButton(
            child: Text(
              'CLOSE',
              style: TextStyle(color: Theme.of(Get.context!).primaryColor),
            ),
            onPressed: () {
              Navigator.of(Get.context!).pop(); // Close the dialog
            },
          ),
        ],
      ).then((value) => {
            if (Get.context != null)
              {CommonFunctions().rateUs(Get.context!, true)}
          });
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('😔 Error Saving PDF'),
        ),
      );
    }
    pdf.value = pw.Document();

    setFileName();
  }

  void viewSavedPDF(File file) {
    Get.to(() => PDFViewer(
          pdfFile: PlatformFile(
            name: basename(file.path),
            path: file.path,
            size: file.lengthSync(),
          ),
         ));
  }

  @override
  void dispose() {
    _fileName.value.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
