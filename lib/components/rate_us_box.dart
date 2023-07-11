import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_to_pdf_converter/constants/common_functions.dart';
import 'package:image_to_pdf_converter/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../size_config.dart';
import 'custom_dialog_widget.dart';
 
class RateUsBox extends StatelessWidget {
  RateUsBox({super.key});
  int selectedStar = -1;
  StreamController<int> persistedController = StreamController<int>();
  showToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Thank you for your feedback",
          style: TextStyle(
            color: aWhite,
          ),
        ),
        backgroundColor: aBlack,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialogWidget(
      title: "Your Review matters",
      subTitle: "Please rate this app",
      child: Container(
          height:  65 ,
          width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: borderRadius13,
            color: aWhite,
            
          ),
          padding: paddingMarginAll15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: persistedController.stream,
                builder: (context, snapshot) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            persistedController.sink.add(index);

                            if (index > 2) {
                              showToast(context);
                              await prefs.setString('reviewed', 'store');
                              
                              CommonFunctions().launchStoreForRating();
                              //open playstore

                              Navigator.pop(context);
                            } else {
                            
                              CommonFunctions().launchMyEmailSubmission(
                                  LaunchMode.externalApplication);
                              await prefs.setString('reviewed', 'mail');
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(
                            !snapshot.hasData
                                ? Icons.star_outline_rounded
                                : snapshot.data as int >= index
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                            color: YellowColor,
                            size:  35  ,
                          ),
                        );
                      });
                },
              )
            ],
          )),
    );
  }
}
