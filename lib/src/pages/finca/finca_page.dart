import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/pages/testPoda/pdf/pdf_api.dart';
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/dialogDelete.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
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
                title: Text('Mis fincas'),
                actions: [
                    TextButton(
                        
                        onPressed: () async{
                            final pdfFile = await PdfApi.generateCenteredText('Hola que haces');
                            print(pdfFile);
                            PdfApi.openFile(pdfFile);
                        }, 
                        child: Row(
                            children: [
                                Icon(Icons.download, color: kwhite, size: 16,),
                                SizedBox(width: 5,),
                                Text('PDF', style: TextStyle(color: Colors.white),)
                            ],
                        )
                        
                    )
                ],
                
            ),
            body: StreamBuilder<List<Finca>>(
                stream: fincasBloc.fincaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());

                    }

                    final fincas = snapshot.data;
                    
                    return Column(
                        children: [
                            Expanded(
                                child: fincas.length == 0
                                ?
                                textoListaVacio('Ingrese datos de finca')
                                :
                                SingleChildScrollView(
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
                    icon: Icons.post_add,
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
                    encabezadoCard('${finca.nombreFinca}','Productor: ${finca.nombreProductor}', 'assets/icons/finca.svg'),
                    textoCardBody('Área de la finca: ${finca.areaFinca} ${finca.tipoMedida == 1 ? 'Mz': 'Ha'}'),
                    tecnico('${finca.nombreTecnico}'),
                    iconTap(' Tocar para agregar parcelas')
                ],
            )
        );
    }

}
