import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_to_pdf_converter/size_config.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_to_pdf_converter/constants/constants.dart';
 import 'package:path/path.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class PDFViewer extends StatefulWidget {
  PDFViewer({
    super.key,
    this.pdfFile,
       this.disableShareButtons,
  });
  final PlatformFile? pdfFile;
    final bool? disableShareButtons;

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer>  {
 

     PDFViewController?  _controller; 

 
 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
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
          ) ,
          title: Text(basenameWithoutExtension(widget.pdfFile!.name),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: aWhite)),
          
        ),
        body: widget.pdfFile != null
            ? PDFView(
                  filePath: widget.pdfFile!.path!,
                   
                  autoSpacing: false,
                  pageFling: false,
                  onRender: (_pages) {
                    
                  },
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    
                    setState(() {
                      _controller = pdfViewController;
                    }); 
                  },
                  onPageChanged: (  page,   total) {
                      setState(() {});
                  },

                ) 
                  // SfPdfViewer.file(
                  //   File(widget.pdfFile!.path!),
                  //   initialZoomLevel: 0,
                    
                  //   pageSpacing: 12,
                  //   onDocumentLoaded: (details) {
                  //     setState(() {});
                  //   },
                  //   onPageChanged: (details) {
                  //     setState(() {});
                  //   },
                  //   controller: _controller,
                  // ),
                  
                 
            : const Text(
                "File not found",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius15,
              ),
              elevation: 5,
              margin: const EdgeInsets.only(left: 30),
              child: SizedBox(
                height: 53.5 ,
                child: Padding(
                  padding: paddingMarginAll12,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: ()async {
                            HapticFeedback.heavyImpact();
                            _controller?.setPage((await (_controller?.getCurrentPage())??0)-1 );
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).badgeTheme.backgroundColor,
                          )),
                      const SizedBox(
                        width: 13,
                      ),
                     FutureBuilder<int?>(
                      future:  _controller?.getCurrentPage(),
                      builder: (context, snapshot) {
                           if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        } else {
                          final currentPage = snapshot.data ?? 0;
                          return FutureBuilder<int?>(
                            future: _controller?.getPageCount(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Error',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                );
                              } else {
                                final pageCount = snapshot.data ?? 0;
                                return Text(
                                  "${currentPage+1} / $pageCount",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                );
                              }
                            },
                          );
                        }
                      },
                    ),

                      const SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                          onTap: () async{
                            HapticFeedback.heavyImpact();
                           _controller?.setPage(
                              (await(_controller?.getCurrentPage()) ?? 0) + 1);
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).badgeTheme.backgroundColor,
                          ))
                    ],
                  ),
                ),
              ),
            ),widget. disableShareButtons!=true?
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15 ),
                  child: FloatingActionButton(
                    onPressed: () async {
                      if( widget.pdfFile != null)
                      await Share.shareFiles([  widget.pdfFile!.path??"" ]);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: aWhite,
                    child: const Icon(Icons.share_rounded),
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    OpenFile.open(  widget.pdfFile!.path!);
                  },
                  label: const Text(
                    'Open With',
                    style: TextStyle(color: aWhite),
                  ),
                  icon: const Icon(Icons.open_in_new),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: aWhite,
                ),
              ],
            ):const SizedBox(),
          ],
        ) 
        
        
        ,
   
    );
  }
}
