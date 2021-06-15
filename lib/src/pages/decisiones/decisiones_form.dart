
import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/models/planta_model.dart';
import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/pages/finca/finca_page.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/snackbar.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:uuid/uuid.dart';

class DesicionesPage extends StatefulWidget {
    DesicionesPage({Key? key}) : super(key: key);

    @override
    _DesicionesPageState createState() => _DesicionesPageState();
}

class _DesicionesPageState extends State<DesicionesPage> {


    Decisiones decisiones = Decisiones();
    List<Decisiones> listaDecisiones = [];
    String? idpodaMain = "";
    bool _guardando = false;
    var uuid = Uuid();
    
    final List<Map<String, dynamic>>  itemPoda = selectMap.podaCacao();
    final List<Map<String, dynamic>>  itemPodaProblema = selectMap.podaProblemas();
    final List<Map<String, dynamic>>  itemPodaAplicar = selectMap.podaAplicar();
    final List<Map<String, dynamic>>  itemDondeAplicar = selectMap.dondeAplicar();
    final List<Map<String, dynamic>>  itemVigorPlanta = selectMap.vigorPlanta();
    final List<Map<String, dynamic>>  itemEntraLuz = selectMap.entraLuz();
    final List<Map<String, dynamic>>  itemMeses = selectMap.listMeses();

    Widget textFalse = Text('0.00%', textAlign: TextAlign.center);
    Widget textmt= Text('0', textAlign: TextAlign.center);
    final Map checksProblemas = {};
    final Map checksPodaAplicar = {};
    final Map checksDondeAplicar = {};
    final Map checksVigorPlanta = {};
    final Map checksEntraLuz = {};
    final Map checksMesPoda = {};

    void checkKeys(){
        for(int i = 0 ; i < itemPodaProblema.length ; i ++){
            checksProblemas[itemPodaProblema[i]['value']] = false;
        }
        for(int i = 0 ; i < itemPodaAplicar.length ; i ++){
            checksPodaAplicar[itemPodaAplicar[i]['value']] = false;
        }
        for(int i = 0 ; i < itemDondeAplicar.length ; i ++){
            checksDondeAplicar[itemDondeAplicar[i]['value']] = false;
        }

        for(int i = 0 ; i < itemVigorPlanta.length ; i ++){
            checksVigorPlanta[itemVigorPlanta[i]['value']] = false;
        }

        for(int i = 0 ; i < itemEntraLuz.length ; i ++){
            checksEntraLuz[itemEntraLuz[i]['value']] = false;
        }
        
        for(int i = 0 ; i < itemMeses.length ; i ++){
           checksMesPoda[itemMeses[i]['value']] = false;
        }
    }
    


    final formKey = new GlobalKey<FormState>();

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
    void initState() {
        super.initState();
        checkKeys();
    }


    @override
    Widget build(BuildContext context) {
        TestPoda? podaTest = ModalRoute.of(context)!.settings.arguments as TestPoda?;
        
       
        Future _getdataFinca() async{
            Finca? finca = await DBProvider.db.getFincaId(podaTest!.idFinca);
            Parcela? parcela = await DBProvider.db.getParcelaId(podaTest.idLote);
            List<Planta> plantas = await DBProvider.db.getTodasPlantaIdTest(podaTest.id);
            return [finca, parcela, plantas];
        }

        

        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
                future: _getdataFinca(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget>? pageItem = [];
                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    
                    pageItem.add(_principalData(finca, parcela, podaTest!.id));
                    pageItem.add(_podaProblemas());   
                    pageItem.add(_podaAplicar());  
                    pageItem.add(_vigorPlanta());   
                    pageItem.add(_accionesMeses());   
                    pageItem.add(_botonsubmit(podaTest.id));   

                    return Column(
                        children: [
                            Container(
                                child: Column(
                                    children: [
                                        TitulosPages(titulo: 'Toma de Decisiones'),
                                        Divider(),
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Text(
                                                "Deslice hacia la derecha para continuar con el formulario",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme
                                                    .headline5!
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
            
            
        );
    }

    Widget _principalData(Finca finca, Parcela parcela, String? podaid){
    
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
                                                Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: InkWell(
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                                Container(                                                                    
                                                                    child: Text(
                                                                        "Datos consolidados",
                                                                        textAlign: TextAlign.center,
                                                                        style: Theme.of(context).textTheme
                                                                            .headline5!
                                                                            .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 10),
                                                                    child: Icon(
                                                                        Icons.info_outline_rounded,
                                                                        color: Colors.green,
                                                                        size: 25.0,
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                        onTap: () => _dialogText(context),
                                                    ),
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
                                                            _countAltura(podaid),
                                                            _countAncho(podaid),
                                                            _countLargo(podaid),
                                                            _countpodas(podaid),
                                                            _countProduccion(podaid),
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
        String? labelMedidaFinca;
        String? labelvariedad;

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
                                        Column(
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
                                                        "Variedad: $labelvariedad ",
                                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                    ),
                                                ),
                                            ],
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
                    child: Text('Estaciones', textAlign: TextAlign.start, style: Theme.of(context).textTheme.headline6!
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),),
                Container(
                    width: 45,
                    child: Text('1', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                    width: 45,
                    child: Text('2', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                    width: 45,
                    child: Text('3', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600))
                ),
                Container(
                    width: 45,
                    child: Text('Total', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!
                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
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
        
        return Column(children: lisItem);
    }

    Widget _countAncho(String? idTest){
        List<Widget> lisItem = [];


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

    Widget _countLargo(String? idTest){
        List<Widget> lisItem = [];


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

    Widget _countpodas(String? idTest){
        List<Widget> lisItem = [];

        for (var i = 0; i < itemPoda.length; i++) {
            String? labelpoda = itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPoda.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('$labelpoda', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
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
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
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


    Widget _podaProblemas(){
        List<Widget> listPrincipales = [];

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
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        for (var i = 0; i < itemPodaProblema.length; i++) {
            String? labelpoda = itemPodaProblema.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listPrincipales.add(

                CheckboxListTile(
                    title: Text('$labelpoda',
                        style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
                    ),
                    value: checksProblemas[itemPodaProblema[i]['value']], 
                    onChanged: (value) {
                        setState(() {
                            checksProblemas[itemPodaProblema[i]['value']] = value;
                            //print(value);
                        });
                    },
                )                    
            );
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

    Widget _podaAplicar(){
        List<Widget> listPodaAplicar = [];

        listPodaAplicar.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Qué tipo de poda debemos aplicar?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var i = 0; i < itemPodaAplicar.length; i++) {
            String? labelProblemaSuelo = itemPodaAplicar.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            listPodaAplicar.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelProblemaSuelo'),
                        value: checksPodaAplicar[itemPodaAplicar[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksPodaAplicar[itemPodaAplicar[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )                  
                    
            );
        }

        listPodaAplicar.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿En qué parte vamos a aplicar las podas?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var i = 0; i < itemDondeAplicar.length; i++) {
            String? labelProblemaSombra = itemDondeAplicar.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listPodaAplicar.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelProblemaSombra'),
                        value: checksDondeAplicar[itemDondeAplicar[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                for(int i = 0 ; i < itemDondeAplicar.length ; i ++){
                                    checksDondeAplicar[itemDondeAplicar[i]['value']] = false;
                                }
                                checksDondeAplicar[itemDondeAplicar[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )                  
                    
            );
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
                child: Column(children:listPodaAplicar,)
            ),
        );
    }

    Widget _vigorPlanta(){
        List<Widget> listVigorPlanta = [];

        listVigorPlanta.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Las plantas tiene suficiente vigor?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var i = 0; i < itemVigorPlanta.length; i++) {
            String? labelProblemaManejo = itemVigorPlanta.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listVigorPlanta.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelProblemaManejo'),
                        value: checksVigorPlanta[itemVigorPlanta[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                for(int i = 0 ; i < itemVigorPlanta.length ; i ++){
                                    checksVigorPlanta[itemVigorPlanta[i]['value']] = false;
                                }
                                checksVigorPlanta[itemVigorPlanta[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )
            );
        }

        listVigorPlanta.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Cómo podemos mejorar la entrada de luz?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        

        for (var i = 0; i < itemEntraLuz.length; i++) {
            String? labelEntradaLuz = itemEntraLuz.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listVigorPlanta.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelEntradaLuz'),
                        value: checksEntraLuz[itemEntraLuz[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                
                                checksEntraLuz[itemEntraLuz[i]['value']] = value;
                            });
                        },
                    ),
                )
            );
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
                child: Column(children:listVigorPlanta,)
            ),
        );
    }

    Widget _accionesMeses(){

        List<Widget> listaAcciones = [];
        listaAcciones.add(
            
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "¿Cúando vamos a realizar las podas?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        for (var i = 0; i < itemMeses.length; i++) {
            String? labelmeses = itemMeses.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listaAcciones.add(
                Container(
                    child: CheckboxListTile(
                        title: Text('$labelmeses'),
                        value: checksMesPoda[itemMeses[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksMesPoda[itemMeses[i]['value']] = value;
                            });
                        },
                    ),
                )
            );
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
                child: Column(children:listaAcciones,)
            ),
        );
    }


    Widget  _botonsubmit(String? idpoda){
        idpodaMain = idpoda;
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                        Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                            child: Text(
                                "¿Ha Terminado todos los formularios de toma de desición?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w600)
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: ButtonMainStyle(
                                title: 'Guardar',
                                icon: Icons.save,
                                press: (_guardando) ? null : _submit,
                            )
                        ),
                    ],
                ),
            ),
        );
    }

    _listaDecisiones(Map checksPreguntas, int pregunta){
       
        checksPreguntas.forEach((key, value) {
            final Decisiones itemDesisiones = Decisiones();
            itemDesisiones.id = uuid.v1();
            itemDesisiones.idPregunta = pregunta;
            itemDesisiones.idItem = int.parse(key);
            itemDesisiones.repuesta = value ? 1 : 0;
            itemDesisiones.idTest = idpodaMain;

            listaDecisiones.add(itemDesisiones);
        });
    }



    void _submit(){
        setState(() {_guardando = true;});
        _listaDecisiones(checksProblemas, 1);
        _listaDecisiones(checksPodaAplicar, 2);
        _listaDecisiones(checksDondeAplicar, 3);
        _listaDecisiones(checksVigorPlanta, 4);
        _listaDecisiones(checksEntraLuz, 5);
        _listaDecisiones(checksMesPoda, 6);


        listaDecisiones.forEach((decision) {
            DBProvider.db.nuevaDecision(decision);
        });
        mostrarSnackbar('Registro decision guardado', context);
        
        fincasBloc.obtenerDecisiones(idpodaMain);
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
    }

}

Future<void> _dialogText(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Titulo'),
                content: SingleChildScrollView(
                    child: ListBody(
                        children: <Widget>[
                        Text('Texto para breve explicacion'),
                        ],
                    ),
                ),
                actions: <Widget>[
                    TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                        Navigator.of(context).pop();
                        },
                    ),
                ],
            );
        },
    );
}