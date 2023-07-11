import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_pdf_converter/constants/common_functions.dart';
import 'package:image_to_pdf_converter/controllers/ads_controller.dart';
import 'package:image_to_pdf_converter/controllers/conversion_controller.dart';
import 'package:image_to_pdf_converter/controllers/open_pdf_controller.dart';
import 'package:image_to_pdf_converter/screens/convert/convert.dart';
import 'package:image_to_pdf_converter/screens/list_saved_pdf/list_saved_pdf.dart';
import 'package:image_to_pdf_converter/size_config.dart';
import 'dart:io';
import '../../components/drawer.dart';
import '../../constants/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:progressive_image/progressive_image.dart';

class Home extends GetView<ConversionController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConversionController());

    SizeConfig().init(context);

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: aWhite,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text(
            'Images to PDF',
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(color: aWhite),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.to(const ListSavedPdf());
                },
                child: Container(
                  padding: paddingMarginAll8,
                  decoration: BoxDecoration(
                    color: PrimaryColorMuchDark,
                    borderRadius: borderRadius10,
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    color: aWhite,
                    size: 20,
                  ),
                )),
            if (controller.isImagesPicked)
              GestureDetector(
                onTap: () {
                  controller.clearAllImages();
                },
                child: Container(
                  padding: paddingMarginAll8,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: PrimaryColorMuchDark,
                    borderRadius: borderRadius10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_sweep_rounded,
                        color: aWhite,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Clear All',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: aWhite),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        drawer: const MainDrawer(),
        body: Container(
            padding: paddingMarginLR12,
            child: controller.isImagesPicked == true
                ? DraggableGridViewBuilder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.6),
                    ),
                    children: List.generate(
                        controller.images.length.isEven
                            ? controller.images.length + 1
                            : controller.images.length + 2,
                        (index) => index == controller.images.length + 0||
                            index ==  controller.images.length + 1
                            ? DraggableGridItem(
                             isDraggable: false, 
                              child: const SizedBox())
                            : DraggableGridItem(
                                isDraggable: true,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2.6,
                                    ),
                                    borderRadius: borderRadius13,
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: borderRadius10,
                                        child: ProgressiveImage(
                                          placeholder: const AssetImage(
                                              'assets/images/home_img2.png'),
                                          // size: 1.87KB
                                          thumbnail: const AssetImage(
                                              'assets/images/placeholder.jpg'),
                                          // size: 1.29MB
                                          image: FileImage(File(
                                              controller.images[index].path!)),
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Padding(
                                        padding: paddingMarginAll5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: text16LightFw500,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .removeImage(index);
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: aWhite,
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      ScaffoldMessenger.of(
                                                              Get.context!)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              '👆 Long press to drag and drop'),
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .drag_indicator_rounded,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 28,
                                                    )),
                                                GestureDetector(
                                                  onTap: () {
                                                    controller.cropImage(
                                                        index, context);
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: aWhite,
                                                    ),
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                    isOnlyLongPress: true,
                    dragPlaceHolder: (list, index) {
                      return PlaceHolderWidget(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.05),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              style: BorderStyle.solid,
                              width: 3,
                            ),
                            borderRadius: borderRadius13,
                          ),
                        ),
                      );
                    },
                    dragCompletion: (List<DraggableGridItem> list,
                        int beforeIndex, int afterIndex) {
                      controller.reArrange(beforeIndex, afterIndex);

                      print('onDragAccept: $beforeIndex -> $afterIndex');
                    },
                    dragFeedback: (List<DraggableGridItem> list, int index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 178,
                        height: 230,
                        decoration: BoxDecoration(
                          color: aWhite,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2.6,
                          ),
                          borderRadius: borderRadius13,
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius10,
                          child: Image.file(
                            File(controller.images[index].path!),
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: paddingMarginLR15,
                          child: const Opacity(
                            opacity: 0.8,
                            child: Image(
                              image: AssetImage('assets/images/home_img2.png'),
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Select Images to Convert',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Click on the button below to select images\nfrom your gallery.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: DarkGray),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          color: Theme.of(context).primaryColor,
          child: ElevatedButton(
              onPressed: controller.isImagesPicked
                  ? () {
                      controller.setFileName();
                      controller.loadBannerAd2();
                      Get.to(() => const Convert());
                    }
                  : () {
                      controller.pickImages();
                    },
              child: Text(
                controller.isImagesPicked ? "Continue" : "Select Images",
                style: text16LightFw500,
              )),
        ),

        floatingActionButton: controller.isImagesPicked == true
            ? Padding(
                padding: controller.isBannerAdReady
                    ? const EdgeInsets.only(bottom: 56)
                    : EdgeInsets.zero,
                child: FloatingActionButton.extended(
                  label: const Text(
                    'Add Images',
                    style: TextStyle(color: aWhite),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: aWhite,
                  ), //child widget inside this button
                  onPressed: () {
                    controller.pickImages();
                  },
                ),
              )
            : null,

        bottomSheet: controller.isBannerAdReady
            ? SizedBox(
                width: double.infinity,
                height: controller.bannerAd?.size.height.toDouble(),
                child: AdWidget(
                  ad: controller.bannerAd!,
                ),
              )
            : null,

        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Color.fromARGB(255, 238, 232, 255),
        //  type: BottomNavigationBarType.fixed,
        //   selectedFontSize: 18,iconSize:24,
        //   selectedIconTheme: IconThemeData(color: Colors.red),
        //   unselectedFontSize:  16,
        //   unselectedItemColor: Colors.grey,

        //   selectedItemColor: Colors.red,
        //   selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, ),
        //   unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500 ),

        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.picture_as_pdf_outlined),
        //       label: 'Convert',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.camera),
        //       label: 'Camera',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: 'Chats',
        //     ),
        //   ],
        // ),
      );
    });
  }
}
