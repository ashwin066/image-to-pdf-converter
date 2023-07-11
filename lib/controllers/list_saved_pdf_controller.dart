import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ListSavedPdfController extends GetxController{
final _isLoading = true.obs;

  RxList<File> pdfFiles = <File>[].obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    listPdfFiles( ).then((value) => pdfFiles.value = value);
  }
  
Future<List<File>> listPdfFiles( ) async {
    final dir = await getExternalStorageDirectory();
   
  final directory = Directory(dir!.path);
  final pdfFiles = <File>[];

  if (await directory.exists()) {
    await for (var entity in directory.list()) {
      if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
        pdfFiles.add(entity);
      }
    }
  } else {
    throw Exception('Directory does not exist');
  }
  _isLoading.value = false;
  return pdfFiles;
}


String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      final kb = (bytes / 1024).toStringAsFixed(1);
      return '${kb}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
      return '${mb}MB';
    } else {
      final gb = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(1);
      return '${gb}GB';
    }
  }
}