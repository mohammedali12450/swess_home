import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressFile(File file) async {
  final dir = await path_provider.getTemporaryDirectory();
  CompressFormat compressFormat = CompressFormat.jpeg;
  if (file.absolute.path.split('/').last.split('.').last == 'png') {
    compressFormat = CompressFormat.png;
  }

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    dir.absolute.path + file.path.split('/').last,
    quality: 30,
    minHeight: 640,
    minWidth: 640,
    format: compressFormat,
  );
  return result!;
}
