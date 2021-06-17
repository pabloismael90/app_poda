import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/dialogDelete.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


final fincasBloc = new FincasBloc();

class TestPage extends StatefulWidget {

    

  @override
  _TestPageState createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {

    
    Future _getdataFinca(TestPoda textPlaga) async{
        Finca? finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        return [finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
        fincasBloc.obtenerPodas();

        return Scaffold(
                appBar: AppBar(),
                body: StreamBuilder<List<TestPoda>>(
                    stream: fincasBloc.podaStream,

                    
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());

                        }

                        List<TestPoda> textPlagas= snapshot.data;
                        if (textPlagas.length == 0) {
                            return Column(
                                children: [
                                    TitulosPages(titulo: 'Parcelas'),
                                    Divider(),
                                    Expanded(child: Center(
                                        child: Text('No hay datos: \nIngrese una toma de datos', 
                                        textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.headline6,
                                            )
                                        )
                                    ),
                                ],
                            );
                        }
                        return Column(
                            children: [

                                TitulosPages(titulo: 'Parcelas'),
                                Divider(),
                                Expanded(child: SingleChildScrollView(child: _listaDePlagas(textPlagas, size, context))),
                            ],
                        );
                        
                        
                    },
                ),
                bottomNavigationBar: botonesBottom(_addtest(context)),
                
                
        );
        
    }

    Widget _addtest(BuildContext context){
        return Row(
            children: [
                Spacer(),
                ButtonMainStyle(
                    title: 'Escoger parcelas',
                    icon: Icons.add_circle_outline_outlined,
                    press: () => Navigator.pushNamed(context, 'addTest'),
                ),
                Spacer()
            ],
        );
    }

    Widget  _listaDePlagas(List textPlagas, Size size, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child: FutureBuilder(
                            future: _getdataFinca(textPlagas[index]),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                }
                                Finca finca = snapshot.data[0];
                                Parcela parcela = snapshot.data[1];

                                return _cardTest(size, textPlagas[index], finca, parcela);
                            },
                        ),
                        onTap: () => Navigator.pushNamed(context, 'estaciones', arguments: textPlagas[index]),
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarTestPoda(textPlagas[index].id),
                );
               
            },
            shrinkWrap: true,
            itemCount: textPlagas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardTest(Size size, TestPoda textPlaga, Finca finca, Parcela parcela){
        
        return cardDefault(
           Column(
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: SvgPicture.asset('assets/icons/test.svg', height:80,),
                            ),
                            Flexible(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    
                                        Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 5.0),
                                            child: Text(
                                                "${finca.nombreFinca}",
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.headline6,
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only( bottom: 4.0),
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
                                                'Fecha: ${textPlaga.fechaTest}',
                                                style: TextStyle(color: kLightBlackColor),
                                            ),
                                        ),
                                    ],  
                                ),
                            ),
                        ],
                    ),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                            Icon(Icons.touch_app, color: kRedColor,),
                            Text(' Tocar para completar datos', style: TextStyle(color: kRedColor),)
                        ],
                    )
                ],
            ),
        );
    }




}