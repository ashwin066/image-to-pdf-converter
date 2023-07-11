
import 'package:flutter/material.dart';
import 'package:image_to_pdf_converter/constants/constants.dart';

import '../size_config.dart';
 

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key, required this.title, this.subTitle, required this.child, this.disableBack});
  final String  title;
  final String? subTitle;
  final Widget child;
  final bool? disableBack;
  @override
  Widget build(BuildContext context) {
    return Dialog(surfaceTintColor: Transparent,
      backgroundColor: Transparent,
      insetPadding: paddingMarginAll20,
      child: Stack(alignment: Alignment.center,
        children: [
          Container(
              margin: paddingMarginAll15,
           
              decoration: BoxDecoration(
                borderRadius: borderRadius13,
                color: aWhite,
                border: border0by8lightGray,
              ),
             
              padding: EdgeInsets.zero,
             
              width: SizeConfig.screenWidth! / 1.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius13.copyWith(bottomLeft: Radius.zero,bottomRight: Radius.zero),
                        color: Theme.of(context).primaryColor,
                       ),
                      width: double.infinity,padding: paddingMarginAll8,
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: text18lightFw500,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            subTitle??"",
                            style: text12LightFw400,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  child
                ],
              )),
   disableBack!=true?       Positioned(
            right: 2,
            top: 2,
            height:32,
            width:32,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                   
                  height:32,
                  width:32,
                  padding: EdgeInsets.zero,
                   decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: aWhite,
                          border: border0by8lightGray,
                        ),
                  child: Icon(
                    Icons.close_rounded,
                    color:  Theme.of(context).primaryColor,
                  )),
            ),
          ):Container()
        ],
      ),
    );
  }
}
