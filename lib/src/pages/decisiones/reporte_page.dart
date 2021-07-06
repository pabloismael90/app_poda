import 'dart:async';
import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/pdf/pdf_api.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ReportePage extends StatefulWidget {


  @override
  _ReportePageState createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
    final List<Map<String, dynamic>>  itemPoda = selectMap.podaCacao();
    final List<Map<String, dynamic>>  itemPodaProblema = selectMap.podaProblemas();
    final List<Map<String, dynamic>>  itemPodaAplicar = selectMap.podaAplicar();
    final List<Map<String, dynamic>>  itemDondeAplicar = selectMap.dondeAplicar();
    final List<Map<String, dynamic>>  itemVigorPlanta = selectMap.vigorPlanta();
    final List<Map<String, dynamic>>  itemEntraLuz = selectMap.entraLuz();
    final List<Map<String, dynamic>>  itemMeses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();
    
    Widget textFalse = Text('0.00%', textAlign: TextAlign.center);
    Widget textmt= Text('0', textAlign: TextAlign.center);
    final Map checksPrincipales = {};

    
    

    Future getdata(TestPoda? testPoda) async{

        List<Decisiones> listDecisiones = await DBProvider.db.getDecisionesIdTest(testPoda!.id);

        Finca? finca = await DBProvider.db.getFincaId(testPoda.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testPoda.idLote);

        return [listDecisiones, finca, parcela];
    }

    Future<double> _countPercentpoda(String? idTest, int estacion, int idpoda) async{
        double? countPalga = await DBProvider.db.countPlagaEstacion(idTest, estacion, idpoda);         
        return countPalga!*100;
    }
    
    Future<double> _countPercentTotal(String? idTest,int idpoda) async{
        double countPalga = await DBProvider.db.countPlagaTotal(idTest, idpoda);         
        return countPalga*100;
    }


    Future<double> _countPercentProduccion(String? idTest, int estacion, int estado) async{
        double countProduccion = await DBProvider.db.countProduccion(idTest, estacion, estado);
        return countProduccion*100;
    }
    Future<double> _countPercentTotalProduccion(String? idTest, int estado) async{
        double countProduccion = await DBProvider.db.countTotalProduccion(idTest, estado);
        return countProduccion*100;
    }
    
    Future<double> _countAlturaEstacion(String? idTest, int estacion) async{
        double countAlturaestacion = await DBProvider.db.countAlturaEstacion(idTest, estacion);
        return countAlturaestacion;
    }
    Future<double> _countAlturaTotal(String? idTest) async{
        double countAlturaTotal = await DBProvider.db.countAlturaTotal(idTest);
        return countAlturaTotal;
    }

    Future<double> _countAnchoEstacion(String? idTest, int estacion) async{
        double countAnchoestacion = await DBProvider.db.countAnchoEstacion(idTest, estacion);
        return countAnchoestacion;
    }
    Future<double> _countAnchoTotal(String? idTest) async{
        double countAnchoTotal = await DBProvider.db.countAnchoTotal(idTest);
        return countAnchoTotal;
    }

    Future<double> _countLargoEstacion(String? idTest, int estacion) async{
        double countLargoestacion = await DBProvider.db.countLargoEstacion(idTest, estacion);
        return countLargoestacion;
    }
    Future<double> _countLargoTotal(String? idTest) async{
        double countLargoTotal = await DBProvider.db.countLargoTotal(idTest);
        return countLargoTotal;
    }

    

    @override
    Widget build(BuildContext context) {
        TestPoda?  testPoda = ModalRoute.of(context)!.settings.arguments as TestPoda;
        
        return Scaffold(
            appBar: AppBar(
                title: Text('Reporte de Decisiones'),
                actions: [
                    TextButton(
                        
                        onPressed: () => _crearPdf(testPoda), 
                        child: Row(
                            children: [
                                Icon(Icons.download, color: kwhite, size: 16,),
                                SizedBox(width: 5,),
                                Text('PDF', style: TextStyle(color: Colors.white),)
                            ],
                        )
                        
                    )
                ],
            ),
            body: FutureBuilder(
                future: getdata(testPoda),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget> pageItem = [];
                    Finca finca = snapshot.data[1];
                    Parcela parcela = snapshot.data[2];

                    pageItem.add(_principalData(testPoda.id,context, finca, parcela));
                    pageItem.add(
                        SingleChildScrollView(
                            child: Column(
                                children:_generatePregunta(snapshot.data[0],'Problemas de poda', 1, itemPodaProblema ),
                            )
                        ) 
                    );
                    pageItem.add(
                        SingleChildScrollView(
                            child: Column(
                                children:[
                                    Column(
                                        children:_generatePregunta(snapshot.data[0],'¿Qué tipo de poda debemos aplicar?', 2, itemPodaAplicar ),
                                    ),
                                    Column(
                                        children:_generatePregunta(snapshot.data[0],'¿En qué parte vamos a aplicar las podas?', 3, itemDondeAplicar ),
                                    )
                                ]
                            )
                        ) 
                    );
                    pageItem.add(
                        SingleChildScrollView(
                            child: Column(
                                children:[
                                    Column(
                                        children:_generatePregunta(snapshot.data[0],'¿Las plantas tiene suficiente vigor?', 4, itemVigorPlanta ),
                                    ),
                                    Column(
                                        children:_generatePregunta(snapshot.data[0],'¿Cómo podemos mejorar la entrada de luz?', 5, itemEntraLuz ),
                                    )
                                ]
                            )
                        ) 
                    );
                    pageItem.add(
                        SingleChildScrollView(
                            child: Column(
                                children:_generatePregunta(snapshot.data[0],'¿Cúando vamos a realizar las podas?', 6, itemMeses ),
                            )
                        )
                    );
                    
                    
                    return Column(
                        children: [                            
                            mensajeSwipe('Deslice hacia la izquierda para continuar con el reporte'),
                            Expanded(
                                
                                child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(15),
                                    child: Swiper(
                                        itemBuilder: (BuildContext context, int index) {
                                            return pageItem[index];
                                        },
                                        itemCount: pageItem.length,
                                        viewportFraction: 1,
                                        loop: false,
                                        scale: 1,
                                    ),
                                ),
                            ),
                        ],
                    );
                },
            ),
        );
    }

    Widget _principalData(String? plagaid, BuildContext context, Finca finca, Parcela parcela){
    
         return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    _dataFincas( context, finca, parcela),
                    Divider(),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                color: Colors.white,
                                child: Column(
                                    children: [
                                        Container(
                                            child: Padding(
                                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                                child: Text(
                                                    "Datos consolidados",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme
                                                        .headline5!
                                                        .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                                                ),
                                            )
                                        ),
                                        Divider(),
                                        Column(
                                            children: [
                                                _encabezadoTabla(),
                                                Divider(),
                                                _countAltura(plagaid),
                                                _countAncho(plagaid),
                                                _countLargo(plagaid),
                                                _countpodas(plagaid),
                                                _countProduccion(plagaid),
                                            ],
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    )
                ],
            ),
        );

            
    }
    
    Widget _dataFincas( BuildContext context, Finca finca, Parcela parcela ){
        String? labelMedidaFinca;
        String? labelvariedad;

        labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];
        labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.variedadCacao}')['label'];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', ''),
                textoCardBody('Productor: ${finca.nombreProductor}'),
                tecnico('${finca.nombreTecnico}'),
                textoCardBody('Variedad: $labelvariedad'),
                Wrap(
                    spacing: 20,
                    children: [
                        textoCardBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)'),
                        textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                        textoCardBody('N de plantas: ${parcela.numeroPlanta}'),
                    ],
                ),
            ],  
        );

    }
    
    Widget _encabezadoTabla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: textList('Sitios')),
                Container(
                    width: 45,
                    child: titleList('1'),
                ),
                Container(
                    width: 45,
                    child: titleList('2'),
                ),
                Container(
                    width: 45,
                    child: titleList('3')
                ),
                Container(
                    width: 45,
                    child: titleList('Total'),
                ),
            ],
        );
    }
    
    Widget _countAltura(String? idTest){
        List<Widget> lisItem = [];


            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('Altura mt')),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAlturaEstacion(idTest, 1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAlturaEstacion(idTest, 2),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAlturaEstacion(idTest, 3),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAlturaTotal(idTest),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisItem.add(Divider());
        
        return Column(children: lisItem);
    }

    Widget _countAncho(String? idTest){
        List<Widget> lisItem = [];


            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('Ancho mt')),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAnchoEstacion(idTest, 1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAnchoEstacion(idTest, 2),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAnchoEstacion(idTest, 3),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countAnchoTotal(idTest),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisItem.add(Divider());
        
        return Column(children:lisItem,);
    }

    Widget _countLargo(String? idTest){
        List<Widget> lisItem = [];


            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('Largo mt')),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countLargoEstacion(idTest, 1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countLargoEstacion(idTest, 2),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countLargoEstacion(idTest, 3),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countLargoTotal(idTest),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textmt;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisItem.add(Divider());
        
        return Column(children:lisItem,);
    }

    Widget _countpodas(String? idTest){
        List<Widget> lisItem = [];

        for (var i = 0; i < itemPoda.length; i++) {
            String? labelpoda = itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('$labelpoda')),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentpoda(idTest, 1, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentpoda(idTest, 2, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentpoda(idTest, 3, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentTotal(idTest, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisItem.add(Divider());
        }
        return Column(children:lisItem,);
    }

    Widget _countProduccion(String? idTest){
        List<Widget> lisProd= [];

        List<String> nameProd = ['Alta','Media','Baja'];

        lisProd.add(
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                        child: Text('Producción', textAlign: TextAlign.start, style: Theme.of(context).textTheme.headline6!
                                .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                    )
                ],
            )
        );
        lisProd.add(Divider());
        for (var i = 0; i < nameProd.length; i++) {
            lisProd.add(

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            child: Text('%${nameProd[i]}', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 1, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 2, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 3, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentTotalProduccion(idTest, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisProd.add(Divider());
        }
        return Column(children:lisProd,);
    }

    List<Widget> _generatePregunta(List<Decisiones> decisionesList, String? titulo, int idPregunta, List<Map<String, dynamic>>  listaItem){
        List<Widget> listWidget = [];
        List<Decisiones> listDecisiones = decisionesList.where((i) => i.idPregunta == idPregunta).toList();

        listWidget.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                titulo as String,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        
        
        for (var item in listDecisiones) {
                String? label= listaItem.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listWidget.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label',
                            style: TextStyle(fontSize: 14),
                        
                        ),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
        }
        return listWidget;
    }



    Future _crearPdf( TestPoda testPoda ) async{
        List<double?> altura =[
            await _countAlturaEstacion(testPoda.id, 1),
            await _countAlturaEstacion(testPoda.id, 2),
            await _countAlturaEstacion(testPoda.id, 3),
            await _countAlturaTotal(testPoda.id),
        ];
        List<double?> ancho =[
            await _countAnchoEstacion(testPoda.id, 1),
            await _countAnchoEstacion(testPoda.id, 2),
            await _countAnchoEstacion(testPoda.id, 3),
            await _countAnchoTotal(testPoda.id),
        ];
        List<double?> largo =[
            await _countLargoEstacion(testPoda.id, 1),
            await _countLargoEstacion(testPoda.id, 2),
            await _countLargoEstacion(testPoda.id, 3),
            await _countLargoTotal(testPoda.id),
        ];
        Map<int,List> produccion = {};

        for (var i = 1; i < 4; i++) {
            int key = i;
            List<double?> valueProduccion =[
                await _countPercentProduccion(testPoda.id, 1, i),
                await _countPercentProduccion(testPoda.id, 2, i),
                await _countPercentProduccion(testPoda.id, 3, i),
                await _countPercentTotalProduccion(testPoda.id, i),
            ];

            produccion.putIfAbsent(key, () => valueProduccion);

        }
        
        Map<int,List> porcentajePoda = {};

        for (var item in itemPoda) {
            int key = int.parse(item['value']);
            List<double?> valueList = [
                await _countPercentpoda(testPoda.id, 1, key),
                await _countPercentpoda(testPoda.id, 2, key),
                await _countPercentpoda(testPoda.id, 3, key),
                await _countPercentTotal(testPoda.id, key),
            ];

            porcentajePoda.putIfAbsent(key, () => valueList);
          
        }      

        
        final pdfFile = await PdfApi.generateCenteredText('${testPoda.id}', altura, ancho, largo, porcentajePoda, produccion);
        
        PdfApi.openFile(pdfFile);
    }

}