import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

/// Resolves employee/group photo paths the same way Win7 `EmployeePhotoStore` does.
class PhotoStore {
  PhotoStore._();

  static Future<Directory> rootDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, AppConstants.photosDir));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static String relativeForEmployee(String employeeId) =>
      '${AppConstants.photosDir}/$employeeId.jpg';

  static String relativeForGroup(String groupId) =>
      '${AppConstants.photosDir}/groups/$groupId.jpg';

  /// [relative] may be `photos/x.jpg` or just `x.jpg`.
  static Future<File?> resolveFile(String? relative) async {
    if (relative == null || relative.trim().isEmpty) return null;
    final clean = relative.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
    final support = await getApplicationSupportDirectory();
    final candidates = <String>[
      p.join(support.path, clean),
      if (!clean.startsWith('${AppConstants.photosDir}/'))
        p.join(support.path, AppConstants.photosDir, clean),
    ];
    for (final path in candidates) {
      final f = File(path);
      if (f.existsSync()) return f;
    }
    return null;
  }

  static Future<bool> exists(String? relative) async {
    final f = await resolveFile(relative);
    return f != null;
  }

  static Future<void> saveEmployeeJpeg(String employeeId, List<int> bytes) async {
    final root = await rootDir();
    final file = File(p.join(root.path, '$employeeId.jpg'));
    await file.writeAsBytes(bytes, flush: true);
  }

  static Future<void> saveGroupJpeg(String groupId, List<int> bytes) async {
    final root = await rootDir();
    final dir = Directory(p.join(root.path, 'groups'));
    if (!dir.existsSync()) await dir.create(recursive: true);
    final file = File(p.join(dir.path, '$groupId.jpg'));
    await file.writeAsBytes(bytes, flush: true);
  }
}
