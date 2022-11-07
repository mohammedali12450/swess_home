import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<File> compressFile(File file) async {
  final dir = await path_provider.getTemporaryDirectory();
  CompressFormat compressFormat = CompressFormat.jpeg;
  if (file.absolute.path.split('/').last.split('.').last == 'png') {
    compressFormat = CompressFormat.png;
  }

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    dir.absolute.path + file.path.split('/').last,
    format: compressFormat,
  );
  return result!;
}
