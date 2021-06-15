import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/card_list.dart';
import 'package:app_poda/src/utils/widget/dialogDelete.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';



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
                                TitulosPages(titulo: 'Mis Fincas'),
                                Divider(),
                                Expanded(child: Center(
                                    child: Text('No hay datos: \nIngrese datos de parcela', 
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.headline6,
                                        )
                                    )
                                ),
                                _addFinca(context),
                                SizedBox(height: 5,)
                            ],
                        );
                    }
                    
                    return Column(
                        children: [
                            TitulosPages(titulo: 'Mis Fincas'),
                            Expanded(child: SingleChildScrollView(
                                child: _listaDeFincas(snapshot.data, context),
                            )),
                            _addFinca(context),
                            SizedBox(height: 5,)
                            

                        ],
                    );
                },
            ),

            // bottomNavigationBar: BottomAppBar(
            //     child: _addFinca(context),
            // ),
            
        );
        
       
    }

    Widget _addFinca(BuildContext context){

        return ButtonMainStyle(
            title: 'Agregar finca',
            icon: Icons.add_circle_outline_outlined,
            press: () => Navigator.pushNamed(context, 'addFinca')
        );
    
       
    }

    Widget  _listaDeFincas(List fincas, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child: CardList(
                            finca: fincas[index],
                            icon:'assets/icons/finca.svg'
                            
                        ),
                        
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
}

