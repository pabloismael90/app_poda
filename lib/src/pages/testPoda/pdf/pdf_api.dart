import 'dart:io';

import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
    static Future<File> generateCenteredText(String text, String idTest) async {
        final pdf = Document();
        final font = Font.ttf(await rootBundle.load('assets/fonts/Museo/Museo300.ttf'));
        
        TestPoda? testplaga = await (DBProvider.db.getTestId(idTest));
        Finca? finca = await DBProvider.db.getFincaId(testplaga!.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testplaga.idLote);

        pdf.addPage(
            MultiPage(
                build: (context) => <Widget>[
                    _encabezado('Datos de finca', font),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            _textoBody('Nombre de finca: ${finca!.nombreFinca}', 14, font, true),
                            _textoBody('Nombre de finca: ${parcela!.nombreLote}', 14, font, false),
                        
                        ]
                    ),
                    
                ]
            )
        );

        return saveDocument(name: 'Reporte.pdf', pdf: pdf);
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

    static Widget _encabezado(String? titulo, Font fuente){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                    titulo as String,
                    style: TextStyle(fontWeight:FontWeight.bold, fontSize: 18, font: fuente)
                ),
                Divider(color: PdfColors.black),
            
            ]
        );

    }


    static Widget _textoBody(String? contenido, double tamano, Font fuente, bool bold){
        print(bold ? FontWeight.bold : FontWeight.normal);

        return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(contenido as String,style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: tamano, font: fuente))
        );

    }
}


