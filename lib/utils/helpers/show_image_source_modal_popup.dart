import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showImageSource(BuildContext context) async {
  if (Platform.isIOS) {
    return showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: const Text('gallery'),
          ),
        ],
      ),
    );
  } else {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Camera'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Gallery'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
