import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// This function returns list as [fileName,fileBytes]
Future<List> filePicker() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result == null || result.files.first.path == null) return [];

  File file = File(result.files.first.path!);

  var temp = result.files.first;
  return [temp.name, file.readAsBytesSync()];
}
