import 'dart:io';

import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:pdf/widgets.dart';

class PdfApi {
    

    static Future<File> generateCenteredText(
        String idTest,
        List<double?> altura,
        List<double?> ancho,
        List<double?> largo,
        Map<int,List> porcentajePoda,
        Map<int,List> produccion,
    
    ) async {
        final pdf = pw.Document();
        final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Museo/Museo300.ttf'));
        
        TestPoda? testplaga = await (DBProvider.db.getTestId(idTest));
        Finca? finca = await DBProvider.db.getFincaId(testplaga!.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testplaga.idLote);
        List<Decisiones> listDecisiones = await DBProvider.db.getDecisionesIdTest(testplaga.id);

        String? labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca!.tipoMedida}')['label'];
        String? labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela!.variedadCacao}')['label'];

        final List<Map<String, dynamic>>  itemPoda = selectMap.podaCacao();
        final List<Map<String, dynamic>>  itemPodaProblema = selectMap.podaProblemas();
        final List<Map<String, dynamic>>  itemPodaAplicar = selectMap.podaAplicar();
        final List<Map<String, dynamic>>  itemDondeAplicar = selectMap.dondeAplicar();
        final List<Map<String, dynamic>>  itemVigorPlanta = selectMap.vigorPlanta();
        final List<Map<String, dynamic>>  itemEntraLuz = selectMap.entraLuz();
        final List<Map<String, dynamic>>  itemMeses = selectMap.listMeses();


        List<String> tituloTable = ['1','2','3','Total'];

        pdf.addPage(
            
            pw.MultiPage(
                pageFormat: PdfPageFormat.a4,
                build: (context) => <pw.Widget>[
                    _encabezado('Datos de finca', font),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                    _textoBody('Finca: ${finca!.nombreFinca}', font),
                                    _textoBody('Parcela: ${parcela!.nombreLote}', font),
                                    _textoBody('Productor: ${finca.nombreProductor}', font),
                                    finca.nombreTecnico != '' ?
                                    _textoBody('Técnico: ${finca.nombreTecnico}', font)
                                    : pw.Container(),

                                    _textoBody('Variedad: $labelvariedad', font),


                                ]
                            ),
                            pw.Container(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                        _textoBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)', font),
                                        _textoBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)', font),
                                        _textoBody('N de plantas: ${parcela.numeroPlanta}', font),                    
                                        _textoBody('Fecha: ${testplaga.fechaTest}', font),                    
                                    ]
                                ),
                            )
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        'Datos consolidados',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: font)
                    ),
                    pw.SizedBox(height: 10),
                    _tablaPoda(tituloTable, altura, ancho, largo, porcentajePoda, font, itemPoda, produccion),
                    pw.SizedBox(height: 10),
                    _pregunta('Problemas de poda', font, listDecisiones, 1, itemPodaProblema),
                    _pregunta('¿Qué tipo de poda debemos aplicar?', font, listDecisiones, 2, itemPodaAplicar),
                    _pregunta('¿En qué parte vamos a aplicar las podas? ', font, listDecisiones, 3, itemDondeAplicar),
                    _pregunta('¿Las plantas tiene suficiente vigor?', font, listDecisiones, 4, itemVigorPlanta),
                    _pregunta('¿Cómo podemos mejorar la entrada de luz?', font, listDecisiones, 5, itemEntraLuz),
                    _pregunta('¿Cúando vamos a realizar las podas?', font, listDecisiones, 6, itemMeses),                   
                    
                ],
                footer: (context) {
                    final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

                    return Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
                        child: Text(
                            text,
                            style: TextStyle(color: PdfColors.black, font: font),
                        ),
                    );
                },
            )
        
        );

        return saveDocument(name: 'Reporte ${finca!.nombreFinca} ${testplaga.fechaTest}.pdf', pdf: pdf);
    }

    static Future<File> saveDocument({
        required String name,
        required pw.Document pdf,
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

    static pw.Widget _encabezado(String? titulo, pw.Font fuente){
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.Text(
                    titulo as String,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fuente)
                ),
                pw.Divider(color: PdfColors.black),
            
            ]
        );

    }

    static pw.Widget _textoBody(String? contenido, pw.Font fuente){
        return pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Text(contenido as String,style: pw.TextStyle(fontSize: 12, font: fuente))
        );

    }

    static pw.Widget _pregunta(String? titulo, pw.Font fuente, List<Decisiones> listDecisiones, int idPregunta, List<Map<String, dynamic>> listaItem){

        List<pw.Widget> listWidget = [];

        listWidget.add(
            _encabezado(titulo, fuente)
        );

        for (var item in listDecisiones) {

            if (item.idPregunta == idPregunta) {
                String? label= listaItem.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listWidget.add(
                    pw.Column(
                        children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                    _textoBody(label, fuente),
                                    pw.Container(
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(color: PdfColors.green900),
                                            borderRadius: pw.BorderRadius.all(
                                                pw.Radius.circular(5.0)
                                            ),
                                            color: item.repuesta == 1 ? PdfColors.green900 : PdfColors.white,
                                        ),
                                        width: 10,
                                        height: 10,
                                        padding: pw.EdgeInsets.all(2),
                                        
                                    )
                                ]
                            ),
                            pw.SizedBox(height: 10)
                        ]
                    ),

                    
                    
                );
            }
        }


        return pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Column(children:listWidget)
        );

    }

    static pw.Widget _tablaPoda( List<String> tituloTable, List<double?> altura, List<double?> ancho, List<double?> largo, Map<int,List> porcentajePoda, Font font, List<Map<String, dynamic>> itemPoda, Map<int, List<dynamic>> produccion,){
        return pw.Column(
            children: [
                pw.Table(
                    columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1:FixedColumnWidth(65),
                        2:FixedColumnWidth(65),
                        3:FixedColumnWidth(65),
                        4:FixedColumnWidth(65),
                    },
                    border: TableBorder.all(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                        _crearFila(tituloTable, 'Sitios', font),
                        _crearFila(altura, 'Altura mt', font),
                        _crearFila(ancho, 'Ancho mt', font),
                        _crearFila(largo, 'Largo mt', font),
                    ]
                ),
                pw.Table(
                    columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1:FixedColumnWidth(65),
                        2:FixedColumnWidth(65),
                        3:FixedColumnWidth(65),
                        4:FixedColumnWidth(65),
                    },
                    border: TableBorder(
                        bottom: BorderSide(color: PdfColors.black, width: 1), 
                        horizontalInside: BorderSide(color: PdfColors.black, width: 1),
                        verticalInside: BorderSide(color: PdfColors.black, width: 1),
                        left: BorderSide(color: PdfColors.black, width: 1),
                        right: BorderSide(color: PdfColors.black, width: 1),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: _filasPoda(itemPoda, porcentajePoda, font)
                ),

                pw.Table(
                    columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1:FixedColumnWidth(65),
                        2:FixedColumnWidth(65),
                        3:FixedColumnWidth(65),
                        4:FixedColumnWidth(65),
                    },
                    border: TableBorder(
                        bottom: BorderSide(color: PdfColors.black, width: 1), 
                        horizontalInside: BorderSide(color: PdfColors.black, width: 1),
                        verticalInside: BorderSide(color: PdfColors.black, width: 1),
                        left: BorderSide(color: PdfColors.black, width: 1),
                        right: BorderSide(color: PdfColors.black, width: 1),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                        _crearFila([], 'Produccion', font),
                        _crearFila(produccion[1] as List<dynamic>, '%Alta', font),
                        _crearFila(produccion[2] as List<dynamic>, '%Media', font),
                        _crearFila(produccion[3] as List<dynamic>, '%Baja', font),
                    ]
                ),
                
            ]
        );

    }

    static pw.TableRow _crearFila(List itemList, String titulo, Font font){
        List<Widget> celdas = [];
        
        celdas.add(_cellText('$titulo', font));
        
        itemList.forEach((item) { 
            celdas.add(_cellText(item.runtimeType == double ? '${item.toStringAsFixed(2)} %' : item, font)); 
        });
        return pw.TableRow(children: celdas);

    }

    static List<pw.TableRow> _filasPoda(List<Map<String, dynamic>> itemPoda , Map<int,List> porcentajePoda, Font font){
        List<pw.TableRow> filas = [];

        porcentajePoda.forEach((key, value) {
            String nameItem = itemPoda.firstWhere((e) => e['value'] == '$key', orElse: () => {"value": "1","label": "No data"})['label'];
            filas.add(_crearFila(value, '$nameItem', font));
            
        });
        return filas;

    }

    static pw.Widget _cellText( String texto, pw.Font font){
        return pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(texto,
                style: pw.TextStyle(font: font)
            )
        );
    }




}


