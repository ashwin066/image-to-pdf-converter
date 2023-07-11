import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_to_pdf_converter/constants/common_functions.dart';
import 'package:image_to_pdf_converter/constants/constants.dart';
import 'package:image_to_pdf_converter/controllers/list_saved_pdf_controller.dart';
import 'package:image_to_pdf_converter/screens/pdf_viewer/pdf_viewer.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
 
class ListSavedPdf extends GetView<ListSavedPdfController> {
  const ListSavedPdf({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ListSavedPdfController());
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          'Saved PDFs',
          style:
              Theme.of(context).textTheme.titleSmall?.copyWith(color: aWhite),
        ),
      ),
      body: Obx(() {
        if (controller.pdfFiles.isEmpty) {
          return const Center(
            child: Text('No PDFs saved yet'),
          );
        } else {
          if (controller.pdfFiles.isEmpty) {
            return const Center(
              child: Text('No PDFs saved yet'),
            );
          } else {
            return ListView.builder(
              itemCount: controller.pdfFiles.length,
              itemBuilder: (context, index) {
                final pdfFile = controller.pdfFiles[index];
                return Padding(
                  padding: controller.pdfFiles.length - 1 == index
                      ? paddingMarginAll15
                      : paddingMarginTLR15,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Get.to(PDFViewer(
                        pdfFile: PlatformFile(
                            name: basename(pdfFile.path),
                            size: pdfFile.lengthSync(),
                            path: pdfFile.path),
                       ));
                    },
                    child: Material(
                      borderRadius: borderRadius13,
                      elevation: 10.0,
                      shadowColor: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: borderRadius13),
                        tileColor: Theme.of(context).canvasColor,
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            basenameWithoutExtension(pdfFile.path),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: borderRadius8),
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: paddingMarginAll5,
                                child: Icon(
                                  Icons.description_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        horizontalTitleGap: 8,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${controller.formatFileSize(File(pdfFile.path).lengthSync())} | ${controller.pdfFiles[index].lastModifiedSync().toString().substring(0, 16)}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: DarkGray),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    HapticFeedback.mediumImpact();
                                    await OpenFile.open(pdfFile.path);
                                  },
                                  icon: const Icon(Icons.folder_open),
                                ),
                                IconButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    CommonFunctions().MyAlertDialog(
                                      context: Get.context!,
                                      title: 'Delete PDF',
                                      icon: Icons.delete_forever,
                                      iconColor: Theme.of(context).primaryColor,
                                      content:
                                          'Are you sure you want to delete ${basename(pdfFile.path)} ?',
                                      actions: [
                                        TextButton(
                                            child: Text(
                                              'DELETE',
                                              style: TextStyle(
                                                  color: Theme.of(Get.context!)
                                                      .primaryColor),
                                            ),
                                            onPressed: () {
                                              controller.pdfFiles
                                                  .removeAt(index);
                                              pdfFile.delete();
                                              Navigator.of(Get.context!)
                                                  .pop(); // Close the dialog
                                            }),
                                        TextButton(
                                          child: Text(
                                            'CLOSE',
                                            style: TextStyle(
                                                color: Theme.of(Get.context!)
                                                    .primaryColor),
                                          ),
                                          onPressed: () {
                                            Navigator.of(Get.context!)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    HapticFeedback.mediumImpact();
                                    if (pdfFile != null)
                                      await Share.shareFiles([pdfFile.path]);
                                  },
                                  icon: const Icon(Icons.share),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      }),
    );
  }
}
