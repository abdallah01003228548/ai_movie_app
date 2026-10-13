import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Wraps [ImagePicker] so widgets and cubits never touch the plugin directly.
///
/// All calls use maxWidth/maxHeight 512 and imageQuality 70, which keeps the
/// encoded base64 well under the 200 KB size guard in [ProfileRepository].
///
/// Registered in GetIt as a lazy singleton (see service_locator.dart).
class ImagePickerService {
  final ImagePicker _picker;

  // Allow injection for testing; production uses the default instance.
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Opens the gallery or camera (depending on [source]) and returns the raw
  /// bytes of the selected image, compressed to at most 512×512 px at quality
  /// 70. Returns null when the user cancels without picking anything.
  ///
  /// Throws a user-readable [Exception] on permission denial or other platform
  /// errors.
  Future<Uint8List?> pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (file == null) return null; // User cancelled

      return await file.readAsBytes();
    } on Exception catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission') || msg.contains('denied')) {
        throw Exception(
          'Permission denied. Please allow photo access in your device settings.',
        );
      }
      if (msg.contains('camera') && msg.contains('unavailable')) {
        throw Exception('No camera is available on this device.');
      }
      throw Exception('Could not pick image: ${e.toString()}');
    }
  }
}
