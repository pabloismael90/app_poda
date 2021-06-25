import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
    static Future<File> generateCenteredText(String text) async {
        final pdf = Document();
        final font = await rootBundle.load('assets/fonts/Museo/Museo300.ttf');
        final otf = Font.ttf(font);

        pdf.addPage(
            MultiPage(
                build: (context) => <Widget>[
                    Header(child: Text(text)),
                ]
            )
        );

        return saveDocument(name: 'my_example.pdf', pdf: pdf);
    }

    static Future<File> saveDocument({
        required String name,
        required Document pdf,
    }) async {
        final bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$name');

        await file.writeAsBytes(bytes);

        return file;
    }

    static Future openFile(File file) async {
        final url = file.path;

        await OpenFile.open(url);
    }
}