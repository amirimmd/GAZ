import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SavedOpenResult {
  const SavedOpenResult({required this.path, this.error});

  final String path;
  final String? error;

  bool get ok => error == null;
}

String? mimeForFileName(String fileName, {String? fallbackMime}) {
  if (fallbackMime != null && fallbackMime.trim().isNotEmpty) {
    return fallbackMime.trim();
  }
  return switch (p.extension(fileName).toLowerCase()) {
    '.pdf' => 'application/pdf',
    '.xlsx' =>
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    '.xls' => 'application/vnd.ms-excel',
    '.csv' => 'text/csv',
    '.png' => 'image/png',
    '.jpg' || '.jpeg' => 'image/jpeg',
    '.gif' => 'image/gif',
    '.webp' => 'image/webp',
    '.txt' => 'text/plain',
    '.doc' => 'application/msword',
    '.docx' =>
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.ppt' => 'application/vnd.ms-powerpoint',
    '.pptx' =>
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    '.zip' => 'application/zip',
    _ => null,
  };
}

/// Writes [bytes] to app temp (openable on Android) and Downloads, then opens.
Future<SavedOpenResult> saveAndOpenFile({
  required Uint8List bytes,
  required String fileName,
  String? mimeType,
}) async {
  final tmp = await getTemporaryDirectory();
  final tmpFile = File(p.join(tmp.path, fileName));
  await tmpFile.writeAsBytes(bytes, flush: true);

  var visiblePath = tmpFile.path;
  try {
    final dl = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    if (!dl.existsSync()) await dl.create(recursive: true);
    final dlFile = File(p.join(dl.path, fileName));
    await dlFile.writeAsBytes(bytes, flush: true);
    visiblePath = dlFile.path;
  } catch (_) {}

  final mime = mimeForFileName(fileName, fallbackMime: mimeType);
  final result = mime == null
      ? await OpenFilex.open(tmpFile.path)
      : await OpenFilex.open(tmpFile.path, type: mime);

  if (result.type != ResultType.done) {
    return SavedOpenResult(
      path: visiblePath,
      error: result.message.isEmpty ? 'باز کردن فایل ناموفق بود' : result.message,
    );
  }
  return SavedOpenResult(path: visiblePath);
}
