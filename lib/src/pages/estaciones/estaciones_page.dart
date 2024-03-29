import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/models/parcela_model.dart';
import 'package:app_poda/src/models/planta_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EstacionesPage extends StatefulWidget {
    const EstacionesPage({Key? key}) : super(key: key);

  @override
  _EstacionesPageState createState() => _EstacionesPageState();
}

class _EstacionesPageState extends State<EstacionesPage> {

    final fincasBloc = new FincasBloc();

    Future _getdataFinca(TestPoda textPlaga) async{
        Finca? finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        List<Decisiones> desiciones = await DBProvider.db.getDecisionesIdTest(textPlaga.id);
        
        return [finca, parcela, desiciones];
    }

    @override
    Widget build(BuildContext context) {
        
        TestPoda poda = ModalRoute.of(context)!.settings.arguments as TestPoda;
        fincasBloc.obtenerPlantas(poda.id);
        

       return StreamBuilder<List<Planta>>(
            stream: fincasBloc.countPlanta,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                List<Planta> plantas= snapshot.data;
                fincasBloc.obtenerDecisiones(poda.id);
                int estacion1 = 0;
                int estacion2 = 0;
                int estacion3 = 0;
                List countEstaciones = [];

                for (var item in plantas) {
                    if (item.estacion == 1) {
                        estacion1 ++;
                    } else if (item.estacion == 2){
                        estacion2 ++;
                    }else{
                        estacion3 ++;
                    }
                }
                countEstaciones = [estacion1,estacion2,estacion3];
                
                return Scaffold(
                    appBar: AppBar(title: Text('Completar datos'),),
                    body: Column(
                        children: [
                            escabezadoEstacion( context, poda ),
                            _textoExplicacion('Lista de sitios'),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: _listaDeEstaciones( context, poda, countEstaciones ),
                                ),
                            ),
                        ],
                    ),
                    bottomNavigationBar: botonesBottom(_tomarDecisiones(countEstaciones, poda)),
                );
            },
        );
    }



    Widget escabezadoEstacion( BuildContext context, TestPoda testPoda ){
        return FutureBuilder(
            future: _getdataFinca(testPoda),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                Finca finca = snapshot.data[0];
                Parcela parcela = snapshot.data[1];

                return Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', 'assets/icons/finca.svg'),
                            Wrap(
                                spacing: 20,
                                children: [
                                    textoCardBody('Productor: ${finca.nombreProductor}'),
                                    textoCardBody('Área finca: ${finca.areaFinca}'),
                                    textoCardBody('Área parcela: ${parcela.areaLote} ${finca.tipoMedida == 1 ? 'Mz': 'Ha'}'), 
                                ],
                            )
                        ],
                    ),
                );
            },
        );        
    }

    Widget _textoExplicacion(String? titulo){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: InkWell(
                child: Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Container(                                                                    
                                    child: Text(
                                        titulo!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
                                    ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.green,
                                        size: 20,
                                    ),
                                ),
                            ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                            children: List.generate(
                                150~/2, (index) => Expanded(
                                    child: Container(
                                        color: index%2==0?Colors.transparent
                                        :kShadowColor2,
                                        height: 2,
                                    ),
                                )
                            ),
                        ),
                    ],
                ),
                onTap: () => _explicacion(context),
            ),
        );
    }

    Widget  _listaDeEstaciones( BuildContext context, TestPoda poda, List countEstaciones){
        return ListView.builder(
            itemBuilder: (context, index) {
                String estadoConteo;
                if (countEstaciones[index] >= 10){
                    estadoConteo =  'Completo';
                }else{
                   estadoConteo =  'Incompleto'; 
                }
                return GestureDetector(
                    
                    child: _cardTest(index+1,countEstaciones[index], estadoConteo),
                    onTap: () => Navigator.pushNamed(context, 'plantas', arguments: [poda, index]),
                );
                
               
            },
            shrinkWrap: true,
            itemCount:  poda.estaciones,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardTest(int estacion, int numeroPlantas, String estado){
        
        return cardDefault(
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    
                    Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                tituloCard('Sitio $estacion'),
                                subtituloCardBody('$estado')
                            ],  
                        ),
                    ),
                    Container(
                        child: CircularPercentIndicator(
                            radius: 70,
                            lineWidth: 5.0,
                            animation: true,
                            percent: numeroPlantas/10,
                            center: new Text("${(numeroPlantas/10)*100}%"),
                            progressColor: Color(0xFF498C37),
                        ),
                    )
                    
                ],
            ), 
                
        );
    }

    Widget  _tomarDecisiones(List countEstaciones, TestPoda poda){
        
        if(countEstaciones[0] >= 10 && countEstaciones[1] >= 10 && countEstaciones[2] >= 10){
            
            return StreamBuilder(
            stream: fincasBloc.decisionesStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                    }
                    List<Decisiones> desiciones = snapshot.data;

                    if (desiciones.length == 0){

                        return Container(
                            color: kBackgroundColor,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                child: ButtonMainStyle(
                                    title: 'Toma de decisiones',
                                    icon: Icons.post_add,
                                    press:() => Navigator.pushNamed(context, 'decisiones', arguments: poda),
                                )
                            ),
                        );
                        
                    }


                    return Container(
                        color: kBackgroundColor,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                            child: ButtonMainStyle(
                                    title: 'Consultar decisiones',
                                    icon: Icons.receipt_rounded,
                                    press: () => Navigator.pushNamed(context, 'reporte', arguments: poda),
                                
                            
                            ),
                        )
                    );
                                       
                },  
            );
        }
        

        return Container(
            color: kBackgroundColor,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                    "Complete los sitios",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900, color: kRedColor, fontSize: 18)
                ),
            ),
        );
    }

    

    Future<void> _explicacion(BuildContext context){

        return dialogText(
            context,
            Column(
                children: [
                    textoCardBody('•	Realizar un recorrido de la parcela SAF cacao para identificar los 3 sitios.'),
                    textoCardBody('•	En cada uno de los sitios, realizar las observaciones sobre la poda en 10 plantas, 5 plantas seguidas sin escoger en un surco y 5 plantas seguidas en el surco vecino y registrar los datos en la aplicación'),
                    textoCardBody('•	Una vez completado la toma de datos de tres sitios la aplicación genera el resumen de los datos con promedios y porcentajes y dirigir al usuario a la sección de toma de decisión.'),
                    textoCardBody('•	Los datos registrados y decisiones tomadas se guardan en el teléfono y se puede generar un informe en formato PDF para compartir con otros.'),
                ],
            ),
            'Pasos para uso de la aplicación de poda'
        );
    }



}