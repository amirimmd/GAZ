import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/core/security/backup_service.dart';
import 'package:gaz_hrms/core/security/crypto_service.dart';
import 'package:path/path.dart' as p;

void main() {
  test('portable backup restores db, docs, and keys without install signature',
      () async {
    final tmp = Directory.systemTemp.createTempSync('gaz_bak_');
    addTearDown(() {
      if (tmp.existsSync()) tmp.deleteSync(recursive: true);
    });

    final srcDb = File(p.join(tmp.path, 'src', 'gaz_hrms.db'));
    await srcDb.parent.create(recursive: true);
    await srcDb.writeAsBytes(List<int>.generate(64, (i) => i));

    final srcDocs = Directory(p.join(tmp.path, 'src_docs'));
    await srcDocs.create(recursive: true);
    final docKey = Uint8List.fromList(List.generate(32, (i) => 40 + i));
    final plain = Uint8List.fromList('secret-doc'.codeUnits);
    final enc = AesGcmService.instance.encrypt(
      key: docKey,
      plaintext: plain,
      aad: Uint8List.fromList('emp1'.codeUnits),
    );
    final srcDoc = File(p.join(srcDocs.path, 'emp1', 'file.enc'));
    await srcDoc.parent.create(recursive: true);
    await srcDoc.writeAsBytes(enc);

    final keys = {
      'db': Uint8List.fromList(List.generate(32, (i) => i)),
      'doc': docKey,
      'sig': Uint8List.fromList(List.generate(32, (i) => 80 + i)),
    };
    Map<String, Uint8List>? imported;

    final svc = BackupService(
      exportKeys: () async => keys,
      importKeys: (m) async => imported = m,
    );

    final out = File(p.join(tmp.path, 'out.gazbak'));
    final created = await svc.createBackup(
      databaseFile: srcDb,
      documentsDir: srcDocs,
      password: 'Backup@123',
      outputFile: out,
    );
    expect(created.isSuccess, isTrue);
    expect(out.existsSync(), isTrue);

    final destDb = File(p.join(tmp.path, 'dest', 'gaz_hrms.db'));
    final destDocs = Directory(p.join(tmp.path, 'dest_docs'));
    await destDocs.create(recursive: true);

    final restored = await svc.restoreBackup(
      backupFile: out,
      password: 'Backup@123',
      targetDb: destDb,
      targetDocs: destDocs,
    );
    expect(restored.isSuccess, isTrue);
    expect(destDb.existsSync(), isTrue);
    expect(destDb.readAsBytesSync(), srcDb.readAsBytesSync());
    expect(imported, isNotNull);
    expect(imported!['doc'], docKey);

    final destEnc = File(p.join(destDocs.path, 'emp1', 'file.enc'));
    expect(destEnc.existsSync(), isTrue);
    final decrypted = AesGcmService.instance.decrypt(
      key: imported!['doc']!,
      payload: destEnc.readAsBytesSync(),
      aad: Uint8List.fromList('emp1'.codeUnits),
    );
    expect(String.fromCharCodes(decrypted), 'secret-doc');

    final bad = await svc.restoreBackup(
      backupFile: out,
      password: 'wrong-pass',
      targetDb: File(p.join(tmp.path, 'bad.db')),
      targetDocs: Directory(p.join(tmp.path, 'bad_docs'))..createSync(),
      applyKeys: false,
    );
    expect(bad.isFailure, isTrue);
  });
}
