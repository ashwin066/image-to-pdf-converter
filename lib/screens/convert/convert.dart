import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_pdf_converter/controllers/conversion_controller.dart';
import 'package:image_to_pdf_converter/size_config.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../../constants/constants.dart';

import 'package:get/get.dart';
import 'package:path/path.dart';

class Convert extends GetView<ConversionController> {
  const Convert({super.key});
  static Map<PdfPageFormat, String> pdfPageFormat = {
    PdfPageFormat.a3: "A3",
    PdfPageFormat.a4: "A4",
    PdfPageFormat.a5: "A5",
    PdfPageFormat.letter: "Letter",
    PdfPageFormat.legal: "Legal",
  };

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
           leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: aWhite,
                ),
                onPressed: () {
                  Get.back();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text(
            "Convert to PDF",
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(color: aWhite),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: paddingMarginAll15,
                child: Column(children: [
                  TextField(
                    controller: controller.fileName,
                    decoration: const InputDecoration(
                        filled: true,
                        labelText: 'File Name',
                        hintText: 'Enter File Name Here'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Margin",
                        style: text13DarkGrayFw500,
                      ),
                      Switch(
                        value: controller.needMargin,
                        onChanged: (value) {
                          controller.setNeedMargin(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Compress Images",
                        style: text13DarkGrayFw500,
                      ),
                      Switch(
                        value: controller.compress_images,
                        onChanged: (value) {
                          controller.setCompressImages(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: controller.compress_images ? 45 : 0,
                    child: AnimatedOpacity(
                      opacity: controller.compress_images ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: paddingMarginL15,
                              child: const Text(
                                "Image Quality",
                                style: text13DarkGrayFw500,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: controller.compress_quality,
                                      onChanged: (value) {
                                        controller.setCompressQuality(value);
                                      },
                                      min: 20.0,
                                      max: 100.0,
                                      divisions: 80,
                                      label: controller.compress_quality
                                          .round()
                                          .toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: Center(
                                        child: Padding(
                                          padding: paddingMarginAll8,
                                          child: Text(
                                            controller.compress_quality
                                                .round()
                                                .toString(),
                                            style: text13LightFw500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Orientation",
                        style: text13DarkGrayFw500,
                      ),
                      DropdownButton<pw.PageOrientation>(
                        value: controller.orientation,
                        onChanged: (pw.PageOrientation? newValue) {
                          controller.setOrientation(newValue!);
                        },
                        items: <pw.PageOrientation>[
                          pw.PageOrientation.portrait,
                          pw.PageOrientation.landscape,
                        ].map<DropdownMenuItem<pw.PageOrientation>>(
                          (pw.PageOrientation value) {
                            return DropdownMenuItem<pw.PageOrientation>(
                              value: value,
                              child: Text(
                                value.toString().split('.')[1].capitalizeFirst!,
                                style: text13DarkGrayFw500,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Page Size",
                        style: text13DarkGrayFw500,
                      ),
                      DropdownButton<PdfPageFormat>(
                        value: controller.pdfPageFormat,
                        onChanged: (PdfPageFormat? newValue) {
                          controller.setPdfPageFormat(newValue!);
                        },
                        items: pdfPageFormat.entries
                            .map<DropdownMenuItem<PdfPageFormat>>(
                          (e) {
                            return DropdownMenuItem<PdfPageFormat>(
                              value: e.key,
                              child: Text(
                                e.value,
                                style: text13DarkGrayFw500,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            if (controller.isLoading)
              Container(
                height: Get.height,
                width: Get.width,
                color: transparentBlack,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: ElevatedButton(
              onPressed: !controller.isLoading
                  ? () async {
                      HapticFeedback.mediumImpact();
                      if (controller.isInterstitialAdReady) {
                        controller.showInterstitialAd(() async {
                          await controller.createPDF();
                        });
                      } else {
                        HapticFeedback.mediumImpact();
                        await controller.createPDF();
                      }
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("⏳Please wait... PDF is being created"),
                        ),
                      );
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Convert to PDF",
                    style: text16LightFw500,
                  ),
                  SizedBox(
                    width: 40,
                    child: controller.isLoading != true
                        ? const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: FittedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.5,
                              ),
                            ),
                          ),
                  )
                ],
              )),
        ),
        bottomSheet: controller.isBannerAd2Ready
            ? SizedBox(
                width: double.infinity,
                height: controller.bannerAd?.size.height.toDouble(),
                child: AdWidget(
                  ad: controller.bannerAd2!,
                ),
              )
            : null,
      ),
    );
  }
}
