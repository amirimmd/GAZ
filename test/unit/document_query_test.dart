import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/domain/entities/document_entity.dart';
import 'package:gaz_hrms/domain/repositories/document_repository.dart';

void main() {
  test('DocumentListQuery equality is stable', () {
    const a = DocumentListQuery(
      searchText: 'حکم',
      tag: 'بیمه',
      category: DocumentCategory.contracts,
    );
    const b = DocumentListQuery(
      searchText: 'حکم',
      tag: 'بیمه',
      category: DocumentCategory.contracts,
    );
    const c = DocumentListQuery(
      searchText: 'حکم',
      tag: 'بیمه',
      category: DocumentCategory.letters,
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a == c, isFalse);
  });
}
