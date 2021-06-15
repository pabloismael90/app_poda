import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/models/parcela_model.dart';
import 'package:app_poda/src/models/planta_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
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
                //print(plantas.length);
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
                    appBar: AppBar(),
                    body: Column(
                        children: [
                            escabezadoEstacion( context, poda ),
                            TitulosPages(titulo: 'Sitios'),
                            Divider(),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: _listaDeEstaciones( context, poda, countEstaciones ),
                                ),
                            ),
                        ],
                    ),
                    bottomNavigationBar: BottomAppBar(
                        child: _tomarDecisiones(countEstaciones, poda)
                    ),
                );
            },
        );
    }



    Widget escabezadoEstacion( BuildContext context, TestPoda poda ){


        return FutureBuilder(
            future: _getdataFinca(poda),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                Finca finca = snapshot.data[0];
                Parcela parcela = snapshot.data[1];

                return Container(
                    
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                                                style: TextStyle(color: kLightBlackColor),
                                            ),
                                        ),
                                        
                                    ],  
                                ),
                            ),
                        ],
                    ),
                );
            },
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
        return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        
                        Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                
                                    Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                        child: Text(
                                            "Sitio $estacion",
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.headline6,
                                        ),
                                    ),
                                    
                                    
                                    Padding(
                                        padding: EdgeInsets.only( bottom: 10.0),
                                        child: Text(
                                            '$estado',
                                            style: TextStyle(color: kLightBlackColor),
                                        ),
                                    ),
                                ],  
                            ),
                        ),
                        Container(
                            child: CircularPercentIndicator(
                                radius: 70.0,
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
                                    icon: Icons.add_circle_outline_outlined,
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
                                    press: () => Navigator.pushNamed(context, 'reporte', arguments: poda.id),
                                
                            
                            ),
                        )
                    );
                                       
                },  
            );
        }
        

        return Container(
            color: kBackgroundColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                    "Complete los sitios",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.w900, color: kRedColor, fontSize: 22)
                ),
            ),
        );
    }
}