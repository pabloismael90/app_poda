import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/dialogDelete.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ParcelaPage extends StatefulWidget {
    ParcelaPage({Key? key}) : super(key: key);

    @override
    _ParcelaPageState createState() => _ParcelaPageState();
}


final fincasBloc = new FincasBloc();
class _ParcelaPageState extends State<ParcelaPage> {

    @override
    Widget build(BuildContext context) {

        final Finca fincaData = ModalRoute.of(context)!.settings.arguments as Finca;
        var size = MediaQuery.of(context).size;
        fincasBloc.obtenerParcelasIdFinca(fincaData.id);

        return Scaffold(
            appBar: AppBar(title: Text('Mis Parcelas'),),
            body: StreamBuilder(
                stream: fincasBloc.parcelaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                    }

                    final parcela = snapshot.data;


                        return Column(
                            children: [
                                _dataFinca(fincaData),
                                parcela.length == 0 ? 
                                Expanded(
                                    child: Center(
                                        child: Text('No hay datos: \nIngrese datos de parcela en la finca', 
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.headline6,
                                        )
                                    )
                                )
                                :
                                TitulosPages(titulo: 'Lista de parcelas'),
                                Expanded(
                                    child: SingleChildScrollView(child: _listaDeParcelas(parcela, fincaData, size, context))
                                ),
                            ],
                        );
            
                    
                },
            ),
            bottomNavigationBar: botonesBottom(
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        _addParcela(fincaData),
                    ],
                ),
            ),
        );
                

        
    }

    // Widget  _editarFinca(Finca finca){
    //     return ButtonMainStyle(
    //         title: 'Editar Finca',
    //         icon: Icons.edit_rounded,
    //         press:() => Navigator.pushNamed(context, 'addFinca', arguments: finca),
    //     );
    // }

    Widget  _addParcela( Finca finca ){
        return ButtonMainStyle(
            title: 'Nueva Parcela',
            icon: Icons.add_circle_outline_outlined,
            press: () => Navigator.pushNamed(context, 'addParcela', arguments: finca),
        );
    }

    Widget _dataFinca(Finca finca){
        return Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            
                            TextButton(
                                onPressed: () => Navigator.pushNamed(context, 'addFinca', arguments: finca),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(kmorado),
                                    
                                ),
                                child: Row(
                                    children: [
                                        Icon(Icons.mode_edit_outlined, color: kwhite, size: 16,),
                                        SizedBox(width: 5,),
                                        Text('Editar', style: TextStyle(color: kwhite, fontWeight: FontWeight.bold),)
                                    ],
                                ),
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
                    :Container(),           

                ],
            ),
        );
    }


    Widget  _listaDeParcelas(List parcelas, Finca finca, Size size, BuildContext context){
        String? labelMedida;
        String? labelVariedad;

        return ListView.builder(
            itemBuilder: (context, index) {
                final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}');
                labelMedida  = item['label'];
                final item2 = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcelas[index].variedadCacao}');
                labelVariedad  = item2['label'];

                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child: _cardDesing(parcelas[index], labelMedida, labelVariedad),
                        onTap: () => Navigator.pushNamed(context, 'addParcela', arguments: parcelas[index]),
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarParcela(parcelas[index].id),
                );
               
            },
            shrinkWrap: true,
            itemCount: parcelas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }


    Widget _cardDesing(Parcela parcela, String? labelMedida, String? labelVariedad){
        
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
                                                child: Text('${parcela.nombreLote}',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ktitulo),
                                                ),
                                            ),
                                            Text('$labelVariedad', 
                                                style: TextStyle(fontWeight: FontWeight.bold, color: kSubtitulo, fontSize: 13)
                                            )
                                        ],
                                    ),
                                ),
                            ),
                            Container(
                                width: 55,
                                child: SvgPicture.asset('assets/icons/parcela.svg', height:55, alignment: Alignment.topCenter),
                            )
                        ],
                    ),
                    Wrap(
                        spacing: 20,
                        children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text('N Plantas: ${parcela.numeroPlanta}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                                )
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text('Área: ${parcela.areaLote} $labelMedida',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                                )
                            ),
                        ],
                    )
                ],
            )
        );
    }




}