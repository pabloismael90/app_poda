import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/existePoda_model.dart';
import 'package:app_poda/src/models/planta_model.dart';

import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class AgregarPlanta extends StatefulWidget {
  @override
  _AgregarPlantaState createState() => _AgregarPlantaState();
}

class _AgregarPlantaState extends State<AgregarPlanta> {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();

    bool _guardando = false;
    int variableVacias = 0;
    int countPlanta = 0;
    var uuid = Uuid();

    Planta planta = Planta();
    ExistePoda existePodaExistePoda = ExistePoda();
    List<ExistePoda> listaPodas = [];

    final fincasBloc = new FincasBloc();
    
    final List<Map<String, dynamic>>  itemPoda = selectMap.podaCacao();
    final Map radios = {};
    void radioGroupKeys(){
        for(int i = 0 ; i < itemPoda.length ; i ++){
            
        radios[itemPoda[i]['value']] = '-1';
        }
    }



    @override
    void initState() {
        super.initState();
        radioGroupKeys();
    }

    @override
    Widget build(BuildContext context) {

        List data = ModalRoute.of(context).settings.arguments;
        
        planta.idTest = data[1];
        planta.estacion = data[0] ;
        countPlanta = data[2]+1;
        
        //return Scaffold();
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            children: <Widget>[
                                TitulosPages(titulo: 'Planta $countPlanta estacion ${planta.estacion}'),
                                Divider(),
                                _altoAncho(),
                                SizedBox( height: 20,),
                                _largoMadera(),
                                SizedBox( height: 20,),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            Expanded(child: Text('', style: Theme.of(context).textTheme.headline6
                                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                                            Container(
                                                width: 50,
                                                child: Text('Si', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                                                .copyWith(fontSize: 16, fontWeight: FontWeight.w600,) ),
                                            ),
                                            Container(
                                                width: 50,
                                                child: Text('No', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                                                .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                                            ),
                                        ],
                                    ),
                                ),
                                Divider(),                                
                                _podaList(),
                                Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Expanded(child: Container(),),
                                        Container(
                                            width: 50,
                                            child: Text('Alta', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600))
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50,
                                            child: Text('Media', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600))
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50,
                                            child: Text('Baja', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600))
                                        ),
                                    ],
                                ),
                                
                                _produccion(),
                                Divider(),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30.0),
                                    child: _botonsubmit()
                                )
                            ],
                        ),
                    ),
                ),
            )

        );
    }

    Widget _altoAncho(){

        return Row(
            children: <Widget>[
                Flexible(
                    child: TextFormField(
                        initialValue: planta.altura.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            labelText: 'Altura en mt'
                        ),
                        validator: (value) {
                            if (double.parse(value) > 0) {
                                return null;
                            } else {
                                return 'Altura mayor a 0';
                            }
                        },
                        onSaved: (value) => planta.altura = double.parse(value),
                    )
                ),
                SizedBox(width: 20.0,),
                Flexible(
                    child: TextFormField(
                        initialValue: planta.ancho.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            labelText: 'Ancho en mt'
                        ),
                        validator: (value) {
                            if (double.parse(value) > 0) {
                                return null;
                            } else {
                                return 'Ancho mayor a cero';
                            }
                        },
                        onSaved: (value) => planta.ancho = double.parse(value),
                    )
                ),
            ],
        );
        
    }

    Widget _largoMadera(){

        return TextFormField(
            initialValue: planta.largo.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Largo de madera productiva'
            ),
            validator: (value) {
                if (double.parse(value) > 0) {
                    return null;
                } else {
                    return 'Largo de madera productiva mayor a cero';
                }
            },
            onSaved: (value) => planta.largo = double.parse(value),
        );
        
    }
    
    

    Widget _podaList(){

        return ListView.builder(
            
            itemBuilder: (BuildContext context, int index) {
                
                String labelPoda = itemPoda.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                int idPoda = int.parse(itemPoda.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "100","label": "No data"})['value']);
                
                
                
                return Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                Expanded(child: Text('$labelPoda', style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                                Transform.scale(
                                    scale: 1.2,
                                    child: Radio(
                                        value: '1',
                                        groupValue: radios[itemPoda[idPoda]['value']],
                                        onChanged: (value){
                                            setState(() {
                                                radios[itemPoda[idPoda]['value']] = value;
                                            });
                                        },
                                        activeColor: Colors.teal[900],
                                    ),
                                ),
                                Transform.scale(
                                    scale: 1.2,
                                    child: Radio(
                                        value:'2',
                                        groupValue: radios[itemPoda[idPoda]['value']],
                                        onChanged: (value){
                                            setState(() {
                                                radios[itemPoda[idPoda]['value']] = value;
                                            });
                                        },
                                        activeColor: Colors.red[900],
                                    ),
                                ),
                            

                            ],
                        ),
                        Divider()
                    ],
                );
        
            },
            shrinkWrap: true,
            itemCount: itemPoda.length,
            physics: NeverScrollableScrollPhysics(),
        );
        
    }

    Widget _produccion(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Producción', style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                Transform.scale(
                    scale: 1.2,
                    child: Radio(
                        value: 1,
                        groupValue: planta.produccion,
                        onChanged: (value) {
                            setState(() {
                                planta.produccion = value;
                            });
                        },
                        activeColor: Colors.teal[900],
                    ),
                ),
                Transform.scale(
                    scale: 1.2,
                    child: Radio(
                        value: 2,
                        groupValue: planta.produccion,
                        onChanged: (value) {
                            setState(() {
                                planta.produccion = value;
                            });
                        },
                        activeColor: Colors.orange[900],
                    ),
                ),
                Transform.scale(
                    scale: 1.2,
                        child: Radio(
                        value: 3,
                        groupValue: planta.produccion,
                        onChanged: (value) {
                            setState(() {
                                planta.produccion = value;
                            });
                        },
                        activeColor: Colors.red[900],
                    ),
                ),   

            ],
        );
        
    }

    

    Widget  _botonsubmit(){
        return RaisedButton.icon(
            icon:Icon(Icons.save, color: Colors.white,),
            
            label: Text('Guardar',
                style: Theme.of(context).textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white)
            ),
            padding:EdgeInsets.symmetric(vertical: 13, horizontal: 50),
            onPressed:(_guardando) ? null : _submit,
        );
    }


    _listaPodas(){

        radios.forEach((key, value) {
            final ExistePoda itemPoda = ExistePoda();
            itemPoda.id = uuid.v1();
            itemPoda.idPlanta = planta.id;
            itemPoda.idPlaga = int.parse(key);
            itemPoda.existe = int.parse(value);


            listaPodas.add(itemPoda);
        });
        
    }

    void _submit(){

        if  ( !formKey.currentState.validate() ){
            //Cuendo el form no es valido
            return null;
        }

        variableVacias = 0;
        radios.forEach((key, value) {
            if (value == '-1') {
                variableVacias ++;
            } 
        });


        if (planta.produccion == 0) {
            variableVacias ++;
        }


        if  ( variableVacias !=  0){
            mostrarSnackbar(variableVacias);
            return null;
        }

        formKey.currentState.save();
        // print(planta.altura);
        // print(planta.ancho);
        // print(planta.largo);


        setState(() {_guardando = true;});

        
        if(planta.id == null){
            planta.id =  uuid.v1();
            _listaPodas();
            fincasBloc.addPlata(planta, planta.idTest, planta.estacion);

            listaPodas.forEach((item) {
                DBProvider.db.nuevoExistePodas(item);
            });

        }
         
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
       
        
    }


    void mostrarSnackbar(int variableVacias){
        final snackbar = SnackBar(
            content: Text('Hay $variableVacias Campos Vacios, Favor llene todo los campos',
                style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
        );
        setState(() {_guardando = false;});
        scaffoldKey.currentState.showSnackBar(snackbar);
    }


}