import 'dart:ui';

import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
// import 'package:app_poda/src/utils/widget/card_list.dart';
import 'package:app_poda/src/utils/widget/dialogDelete.dart';
// import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class FincasPage extends StatefulWidget {
    @override
    _FincasPageState createState() => _FincasPageState();
}

final fincasBloc = new FincasBloc();


class _FincasPageState extends State<FincasPage> {


    @override
    Widget build(BuildContext context) {

        fincasBloc.obtenerFincas();
        return Scaffold(
            appBar: AppBar(
                title: Text('Mis fincas')
            ),
            body: StreamBuilder<List<Finca>>(
                stream: fincasBloc.fincaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());

                    }

                    final fincas = snapshot.data;
                    if (fincas.length == 0) {
                        return Column(
                            children: [
                                Expanded(child: Center(
                                    child: Text('No hay datos: \nIngrese datos de parcela', 
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
                            Expanded(
                                child: SingleChildScrollView(
                                    child: _listaDeFincas(snapshot.data, context),
                                )
                            ),
                        ],
                    );
                },
            ),

            bottomNavigationBar: botonesBottom(_addFinca(context))
            
        );
        
       
    }

    Widget _addFinca(BuildContext context){
        return Row(
            children: [
                Spacer(),
                ButtonMainStyle(
                    title: 'Agregar finca',
                    icon: Icons.add_circle_outline_outlined,
                    press: () => Navigator.pushNamed(context, 'addFinca')
                ),
                Spacer()
            ],
        );
    }

    Widget  _listaDeFincas(List fincas, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child: _cardDesing(fincas[index]),
                        onTap: () => Navigator.pushNamed(context, 'parcelas', arguments: fincas[index]),
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarFinca(fincas[index].id),
                );
                
               
            },
            shrinkWrap: true,
            itemCount: fincas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardDesing(Finca finca){
        return cardDefault(
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Flexible(
                                child: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                child: Text('${finca.nombreFinca}',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ktitulo),
                                                ),
                                            ),
                                            Text('Productor: ${finca.nombreProductor}', 
                                                style: TextStyle(fontWeight: FontWeight.bold, color: kSubtitulo, fontSize: 13)
                                            )
                                        ],
                                    ),
                                ),
                            ),
                            Container(
                                width: 55,
                                child: SvgPicture.asset('assets/icons/finca.svg', height:55, alignment: Alignment.topCenter),
                            )
                        ],
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Área de la finca: ${finca.areaFinca} ${finca.tipoMedida == 1 ? 'Mz': 'Ha'}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                        )
                    ),
                    finca.nombreTecnico != '' 
                    ?Container(
                        child: Text('Técnico: ${finca.nombreTecnico}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))
                    )
                    : Container()
                ],
            )
        );
    }

}
