import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
//import 'package:app_poda/src/pages/decisiones/pdf_view.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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

    
    

    Future getdata(String idTest) async{

        List<Decisiones> listDecisiones = await DBProvider.db.getDecisionesIdTest(idTest);
        TestPoda testplaga = await DBProvider.db.getTestId(idTest);

        Finca finca = await DBProvider.db.getFincaId(testplaga.idFinca);
        Parcela parcela = await DBProvider.db.getParcelaId(testplaga.idLote);

        return [listDecisiones, finca, parcela];
    }

    Future<double> _countPercentPlaga(String idTest, int estacion, int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaEstacion(idTest, estacion, idPlaga);         
        return countPalga*100;
    }
    
    Future<double> _countPercentTotal(String idTest,int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaTotal(idTest, idPlaga);         
        return countPalga*100;
    }

    
    Future<double> _countPercentProduccion(String idTest, int estacion, int estado) async{
        double countProduccion = await DBProvider.db.countProduccion(idTest, estacion, estado);
        return countProduccion*100;
    }

    Future<double> _countPercentTotalProduccion(String idTest, int estado) async{
        double countProduccion = await DBProvider.db.countTotalProduccion(idTest, estado);
        return countProduccion*100;
    }

    Future<double> _countAlturaEstacion(String idTest, int estacion) async{
        double countAlturaestacion = await DBProvider.db.countAlturaEstacion(idTest, estacion);
        return countAlturaestacion/10;
    }
    Future<double> _countAlturaTotal(String idTest) async{
        double countAlturaTotal = await DBProvider.db.countAlturaTotal(idTest);
        return countAlturaTotal/30;
    }

    Future<double> _countAnchoEstacion(String idTest, int estacion) async{
        double countAnchoestacion = await DBProvider.db.countAnchoEstacion(idTest, estacion);
        return countAnchoestacion/10;
    }
    Future<double> _countAnchoTotal(String idTest) async{
        double countAnchoTotal = await DBProvider.db.countAnchoTotal(idTest);
        return countAnchoTotal/30;
    }

    Future<double> _countLargoEstacion(String idTest, int estacion) async{
        double countLargoestacion = await DBProvider.db.countLargoEstacion(idTest, estacion);
        return countLargoestacion/10;
    }
    Future<double> _countLargoTotal(String idTest) async{
        double countLargoTotal = await DBProvider.db.countLargoTotal(idTest);
        return countLargoTotal/30;
    }

    

    @override
    Widget build(BuildContext context) {
        String idTest = ModalRoute.of(context).settings.arguments;

        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
                future: getdata(idTest),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget> pageItem = List<Widget>();
                    Finca finca = snapshot.data[1];
                    Parcela parcela = snapshot.data[2];

                    pageItem.add(_principalData(idTest,context, finca, parcela));
                    
                    pageItem.add( _podaProblemas(snapshot.data[0]));
                    _plagasPDF(idTest,1);
                    pageItem.add( _podaAplicar(snapshot.data[0]));
                    pageItem.add( _vigorPlanta(snapshot.data[0]));
                    pageItem.add( _accionesMeses(snapshot.data[0]));
                    
                    
                    return Column(
                        children: [
                            Container(
                                child: Column(
                                    children: [
                                        
                                        TitulosPages(titulo: 'Reporte de Decisiones'),
                                        Divider(),
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Text(
                                                "Deslice hacia la derecha para continuar con el reporte",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme
                                                    .headline5
                                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                                            ),
                                        ),
                                    ],
                                )
                            ),
                            Expanded(
                                
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
                        ],
                    );
                },
            ),
            // floatingActionButton: FloatingActionButton(
            //     child: Icon(Icons.save_alt),     
            //     onPressed: ()async{
            //         writePDF();
            //         await savePDF();
            //         Directory documentsDirectory = await getExternalStorageDirectory();
            //         String documentPath = documentsDirectory.path;
            //         String fullPath = "$documentPath/example.pdf";
            //         Navigator.push(context, MaterialPageRoute(
            //             builder: (context) => PDFView(fullPath)
            //         ));
            //     },
            // ),
        );
    }

    Widget _principalData(String plagaid, BuildContext context, Finca finca, Parcela parcela){
    
         return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    _dataFincas( context, finca, parcela),

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
                                                        .headline5
                                                        .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                                                ),
                                            )
                                        ),
                                        Divider(),
                                        Container(
                                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                    BoxShadow(
                                                            color: Color(0xFF3A5160)
                                                                .withOpacity(0.05),
                                                            offset: const Offset(1.1, 1.1),
                                                            blurRadius: 17.0),
                                                    ],
                                            ),
                                            child: Column(
                                                children: [
                                                    _encabezadoTabla(),
                                                    Divider(),
                                                    _countAltura(plagaid),
                                                    _countAncho(plagaid),
                                                    _countLargo(plagaid),
                                                    _countPlagas(plagaid, 1),
                                                    _countProduccion(plagaid),
                                                ],
                                            ),
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
        String labelMedidaFinca;
        String labelvariedad;

        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}');
        labelMedidaFinca  = item['label'];

        final itemvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.variedadCacao}');
        labelvariedad  = itemvariedad['label'];

        return Container(
                    
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                    BoxShadow(
                            color: Color(0xFF3A5160)
                                .withOpacity(0.05),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 17.0),
                    ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    
                    Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            
                                Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                    child: Text(
                                        "${finca.nombreFinca}",
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.headline6,
                                    ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only( bottom: 10.0),
                                    child: Text(
                                        "${parcela.nombreLote}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only( bottom: 10.0),
                                    child: Text(
                                        "Productor ${finca.nombreProductor}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                ),

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Padding(
                                                    padding: EdgeInsets.only( bottom: 10.0),
                                                    child: Text(
                                                        "Área Finca: ${finca.areaFinca} ($labelMedidaFinca)",
                                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                    ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only( bottom: 10.0),
                                                    child: Text(
                                                        "N de plantas: ${parcela.numeroPlanta}",
                                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        Flexible(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Padding(
                                                        padding: EdgeInsets.only( bottom: 10.0, left: 20),
                                                        child: Text(
                                                            "Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)",
                                                            style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only( bottom: 10.0, left: 20),
                                                        child: Text(
                                                            "Variedad: $labelvariedad",
                                                            style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        )
                                    ],
                                )

                                
                            ],  
                        ),
                    ),
                ],
            ),
        );

    }

    Widget _encabezadoTabla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Estaciones', textAlign: TextAlign.start, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),),
                Container(
                    width: 45,
                    child: Text('1', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                    width: 45,
                    child: Text('2', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                    width: 45,
                    child: Text('3', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600))
                ),
                Container(
                    width: 45,
                    child: Text('Total', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
            ],
        );
    }

    Widget _countAltura(String idTest){
        List<Widget> lisItem = List<Widget>();


            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Altura mt', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
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
        
        return Column(children:lisItem,);
    }

    Widget _countAncho(String idTest){
        List<Widget> lisItem = List<Widget>();


            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Ancho mt', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
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

    Widget _countLargo(String idTest){
        List<Widget> lisItem = List<Widget>();


            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Largo mt', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
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

    Widget _countPlagas(String idTest, int estacion){
        List<Widget> lisItem = List<Widget>();

        for (var i = 0; i < itemPoda.length; i++) {
            String labelPlaga = itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('$labelPlaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 1, idplga),
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
                                future: _countPercentPlaga(idTest, 2, idplga),
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
                                future: _countPercentPlaga(idTest, 3, idplga),
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

    Widget _countProduccion(String idTest){
        List<Widget> lisProd= List<Widget>();

        List<String> nameProd = ['Alta','Media','Baja'];

        lisProd.add(
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('Producción', textAlign: TextAlign.start, style: Theme.of(context).textTheme.headline6
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
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
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

    Widget _podaProblemas(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "Problemas de poda",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var item in decisionesList) {

            if (item.idPregunta == 1) {
                String label = itemPodaProblema.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                        
                );
            }
            
        }
        
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(children:listPrincipales,)
            ),
        );
        
    }

    Widget _podaAplicar(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Qué tipo de poda debemos aplicar?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var item in decisionesList) {

            if (item.idPregunta == 2) {
                String label= itemPodaAplicar.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
            
        }

        listPrincipales.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿En qué parte vamos a aplicar las pod",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var item in decisionesList) {

            if (item.idPregunta == 3) {
                String label= itemDondeAplicar.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
            
        }
        
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(children:listPrincipales,)
            ),
        );
        
    }

    Widget _vigorPlanta(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Las plantas tiene suficiente vigor?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var item in decisionesList) {

            if (item.idPregunta == 4) {
                String label= itemVigorPlanta.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
        }

        listPrincipales.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Las plantas tiene suficiente vigor?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var item in decisionesList) {

            if (item.idPregunta == 5) {
                String label= itemEntraLuz.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
        }
        
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(children:listPrincipales,)
            ),
        );
        
    }
    
    Widget _accionesMeses(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Cúando vamos a realizar las podas?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        
        
        for (var item in decisionesList) {

            if (item.idPregunta == 6) {
                String label= itemMeses.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
        }
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(children:listPrincipales,)
            ),
        );
    }


    Widget _plagasPDF(String idTest, int estacion){
        List<Widget> lisItem = List<Widget>();

        for (var i = 0; i < itemPoda.length; i++) {
            String labelPlaga = itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('$labelPlaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
                        Container(
                            width: 45,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 1, idplga),
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
                                future: _countPercentPlaga(idTest, 2, idplga),
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
                                future: _countPercentPlaga(idTest, 3, idplga),
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
        }
        return Column(children:lisItem,);
    }



   

    


}