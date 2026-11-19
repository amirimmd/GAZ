import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Embeds a PNG as a floating logo in the first worksheet of an xlsx archive.
Uint8List embedPngLogoInXlsx(Uint8List xlsxBytes, Uint8List pngBytes) {
  if (pngBytes.isEmpty) return xlsxBytes;
  final archive = ZipDecoder().decodeBytes(xlsxBytes);
  final sheetName = archive.files
      .map((f) => f.name)
      .firstWhere(
        (n) => n.startsWith('xl/worksheets/sheet') && n.endsWith('.xml'),
        orElse: () => '',
      );
  if (sheetName.isEmpty) return xlsxBytes;

  final sheetFile = archive.findFile(sheetName);
  if (sheetFile == null) return xlsxBytes;
  var sheetXml = utf8.decode(sheetFile.content as List<int>);
  if (sheetXml.contains('<drawing ')) return xlsxBytes;

  const drawingPath = 'xl/drawings/drawing1.xml';
  const drawingRelsPath = 'xl/drawings/_rels/drawing1.xml.rels';
  const mediaPath = 'xl/media/image1.png';
  final sheetRelsPath =
      'xl/worksheets/_rels/${sheetName.split('/').last}.rels';

  const drawingXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xdr:wsDr xmlns:xdr="http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
  <xdr:twoCellAnchor editAs="oneCell">
    <xdr:from><xdr:col>0</xdr:col><xdr:colOff>80000</xdr:colOff><xdr:row>0</xdr:row><xdr:rowOff>40000</xdr:rowOff></xdr:from>
    <xdr:to><xdr:col>1</xdr:col><xdr:colOff>400000</xdr:colOff><xdr:row>3</xdr:row><xdr:rowOff>0</xdr:rowOff></xdr:to>
    <xdr:pic>
      <xdr:nvPicPr>
        <xdr:cNvPr id="1" name="Logo"/>
        <xdr:cNvPicPr><a:picLocks noChangeAspect="1"/></xdr:cNvPicPr>
      </xdr:nvPicPr>
      <xdr:blipFill>
        <a:blip xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" r:embed="rId1"/>
        <a:stretch><a:fillRect/></a:stretch>
      </xdr:blipFill>
      <xdr:spPr>
        <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
      </xdr:spPr>
    </xdr:pic>
    <xdr:clientData/>
  </xdr:twoCellAnchor>
</xdr:wsDr>''';

  const drawingRels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="../media/image1.png"/>
</Relationships>''';

  final sheetRels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rIdLogo" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing" Target="../drawings/drawing1.xml"/>
</Relationships>''';

  if (!sheetXml.contains('</worksheet>')) return xlsxBytes;
  if (!sheetXml.contains('xmlns:r=')) {
    sheetXml = sheetXml.replaceFirst(
      '<worksheet',
      '<worksheet xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"',
    );
  }
  sheetXml = sheetXml.replaceFirst(
    '</worksheet>',
    '<drawing r:id="rIdLogo"/></worksheet>',
  );

  final typesFile = archive.findFile('[Content_Types].xml');
  var typesXml = typesFile == null
      ? '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"></Types>'''
      : utf8.decode(typesFile.content as List<int>);
  if (!typesXml.contains('Extension="png"')) {
    typesXml = typesXml.replaceFirstMapped(
      RegExp(r'<Types[^>]*>'),
      (m) => '${m[0]}<Default Extension="png" ContentType="image/png"/>',
    );
  }
  if (!typesXml.contains('/xl/drawings/drawing1.xml')) {
    typesXml = typesXml.replaceFirst(
      '</Types>',
      '<Override PartName="/xl/drawings/drawing1.xml" ContentType="application/vnd.openxmlformats-officedocument.drawing+xml"/></Types>',
    );
  }

  final out = Archive();
  for (final f in archive.files) {
    if (!f.isFile) continue;
    if (f.name == sheetName || f.name == '[Content_Types].xml') continue;
    out.addFile(f);
  }
  void add(String name, List<int> data) {
    out.addFile(ArchiveFile(name, data.length, data));
  }

  add(sheetName, utf8.encode(sheetXml));
  add('[Content_Types].xml', utf8.encode(typesXml));
  add(drawingPath, utf8.encode(drawingXml));
  add(drawingRelsPath, utf8.encode(drawingRels));
  add(sheetRelsPath, utf8.encode(sheetRels));
  add(mediaPath, pngBytes);

  final encoded = ZipEncoder().encode(out);
  return encoded == null ? xlsxBytes : Uint8List.fromList(encoded);
}
