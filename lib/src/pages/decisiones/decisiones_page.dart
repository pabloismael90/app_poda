
import 'dart:async';

import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DesicionesList extends StatelessWidget {
    const DesicionesList({Key? key}) : super(key: key);

    
    Future getRegistros() async{
        
        List<Decisiones> listAcciones= await DBProvider.db.getTodasDesiciones();

        return listAcciones;
    }

    Future getDatos(String? id) async{
        
        TestPoda testplaga= await (DBProvider.db.getTestId(id) as FutureOr<TestPoda>);

        Finca? finca = await DBProvider.db.getFincaId(testplaga.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testplaga.idLote);

        return [testplaga, finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        
        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
                future: getRegistros(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    return Column(
                        children: [
                            TitulosPages(titulo: 'Reportes'),
                            Divider(),
                            Expanded(child: _listaDePlagas(snapshot.data, context))
                        ],
                    );

                },
            ),
        );
    }

    Widget  _listaDePlagas(List acciones, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child : FutureBuilder(
                        future: getDatos(acciones[index].idTest),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                            }
                            TestPoda testplagadata = snapshot.data[0];
                            Finca fincadata = snapshot.data[1];
                            Parcela parceladata = snapshot.data[2];

                            return _cardDesiciones(testplagadata,fincadata,parceladata, context);
                        },
                    ),
                    
                    onTap: () => Navigator.pushNamed(context, 'reporte', arguments: acciones[index].idTest),
                    //onTap: () => print (acciones[index].idTest),
                );
               
            },
            shrinkWrap: true,
            itemCount: acciones.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardDesiciones(TestPoda textPlaga, Finca finca, Parcela parcela, BuildContext context){
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: SvgPicture.asset('assets/icons/report.svg', height:80,),
                        ),
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
                                    
                                    Padding(
                                        padding: EdgeInsets.only( bottom: 10.0),
                                        child: Text(
                                            'Toma de datos: ${textPlaga.fechaTest}',
                                            style: TextStyle(color: kLightBlackColor),
                                        ),
                                    ),
                                ],  
                            ),
                        ),
                        
                        
                        
                    ],
                ),
        );
    }
   
}