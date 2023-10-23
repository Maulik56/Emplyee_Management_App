import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/cupertino.dart';

import '../components/common_widget.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:news_app/repo/add_new_resource_repo.dart';
import 'resource_finder_screen.dart';

class PhotoViewScreen extends StatefulWidget {
  final String? markerId;
  PhotoViewScreen({Key? key, this.markerId}) : super(key: key);

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  final NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.commonAppBar(
        title: "Resource Viewer",
        leading: InkResponse(
          onTap: () {
            _navigationService.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Text('DELETE RESOURCE?'),
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: <CupertinoActionSheetAction>[
                        CupertinoActionSheetAction(
                          child: const Text('Yes, delete resource'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                            AddNewResourceRepo.deleteResource(widget.markerId!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: PhotoView(
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
        imageProvider:
            NetworkImage("${AppImages.mapMarkerPhotoPrefix}${widget.markerId}"),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
      ),
    );
  }
}
