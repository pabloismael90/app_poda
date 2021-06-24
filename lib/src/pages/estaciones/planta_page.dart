
import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/planta_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/dialogDelete.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlantaPage extends StatefulWidget {
  @override
  _PlantaPageState createState() => _PlantaPageState();
}

class _PlantaPageState extends State<PlantaPage> {

    final fincasBloc = new FincasBloc();

    @override
    Widget build(BuildContext context) {
        List dataEstaciones = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        TestPoda plaga = dataEstaciones[0];
        int? indiceEstacion = dataEstaciones[1]+1;
        fincasBloc.obtenerPlantaIdTest(plaga.id, indiceEstacion);

        return Scaffold(
            appBar: AppBar(title: Text('Lista plantas sitio $indiceEstacion'),),
            body: StreamBuilder<List<Planta>>(
                stream: fincasBloc.plantaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    //print(snapshot.data);
                    final planta = snapshot.data;

                    return Column(
                        children: [ 
                            Expanded(
                                child: planta.length == 0
                                ?
                                textoListaVacio('Ingrese datos de plantas')
                                :
                                SingleChildScrollView(child: _listaDePlantas(planta, context, indiceEstacion)),
                            ),
                        ],
                    );

                },
            ),
            bottomNavigationBar: botonesBottom(_countPlanta(plaga.id, indiceEstacion, plaga) ),
        );
    }

    


    Widget  _listaDePlantas(List planta, BuildContext context, int? numeroEstacion){

        return ListView.builder(
            itemBuilder: (context, index) {
                if (planta[index].estacion == numeroEstacion) {
                    return Dismissible(
                        key: UniqueKey(),
                        child: GestureDetector(
                            child:cardDefault(
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        tituloCard('Planta ${index+1}'),
                                        Wrap(
                                            spacing: 15,
                                            children: [
                                                textoCardBody('Alto: ${planta[index].altura}'),
                                                textoCardBody('Alto: ${planta[index].ancho}'),
                                                textoCardBody('Alto: ${planta[index].largo}'),
                                            ],
                                        )
                                    ],
                                ),
                            ),
                        ),
                        confirmDismiss: (direction) => confirmacionUser(direction, context),
                        direction: DismissDirection.endToStart,
                        background: backgroundTrash(context),
                        movementDuration: Duration(milliseconds: 500),
                        onDismissed: (direction) => fincasBloc.borrarPlanta(planta[index]),
                    );
                }
                return Container();
            },
            shrinkWrap: true,
            itemCount: planta.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    

    Widget  _countPlanta(String? idPlaga,  int? estacion, TestPoda plaga){
        return StreamBuilder<List<Planta>>(
            stream: fincasBloc.plantaStream,
            
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                List<Planta> plantas = snapshot.data;
                
                int value = plantas.length;
                
                if (value < 10) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            textoBottom('Plantas: $value / 10', kTextColor),
                            _addPlanta(context, estacion, plaga, value),
                        ],
                    );
                }else{
                    if (estacion! <= 2){
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                textoBottom('Plantas: $value / 10',  kTextColor),
                                ButtonMainStyle(
                                    title: 'Siguiente Sitio',
                                    icon: Icons.navigate_next_rounded,
                                    press: () => Navigator.popAndPushNamed(context, 'plantas', arguments: [plaga, estacion]),
                                )
                            ],
                        );
                    }else{
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                Container(
                                    child: Text('Plantas: $value / 10',
                                        style: Theme.of(context).textTheme
                                                .headline6!
                                                .copyWith(fontWeight: FontWeight.w600)
                                    ),
                                ),
                                ButtonMainStyle(
                                    title: 'Lista de sitios',
                                    icon: Icons.chevron_left,
                                    press:() => Navigator.pop(context),
                                )
                            ],
                        );
                    }

                    
                }                
            },
        );
    }


    Widget  _addPlanta(BuildContext context,  int? estacion, TestPoda plaga, int value){
        return ButtonMainStyle(
            title: 'Agregar Planta',
            icon: Icons.post_add,
            press:() => Navigator.pushNamed(context, 'addPlanta', arguments: [estacion,plaga.id,value]),
        );
    }

}