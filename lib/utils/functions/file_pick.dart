import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickFiles() {
  // Pick Files from the device works on both web and mobile
  return FilePicker.platform.pickFiles(type: FileType.image);
}
