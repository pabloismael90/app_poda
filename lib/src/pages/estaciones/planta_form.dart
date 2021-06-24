import 'package:app_poda/src/bloc/fincas_bloc.dart';
import 'package:app_poda/src/models/existePoda_model.dart';
import 'package:app_poda/src/models/planta_model.dart';
import 'package:app_poda/src/utils/validaciones.dart' as utils;
import 'package:app_poda/src/models/selectValue.dart' as selectMap;
import 'package:app_poda/src/providers/db_provider.dart';
import 'package:app_poda/src/utils/widget/button.dart';
import 'package:app_poda/src/utils/widget/varios_widget.dart';
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
    int? countPlanta = 0;
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

        List data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        
        planta.idTest = data[1];
        planta.estacion = data[0] ;
        countPlanta = data[2]+1;
        
        String tituloForm = 'Sitio ${planta.estacion} planta $countPlanta';
        String tituloBtn = 'Guardar';
        
        
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text(tituloForm),),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            children: <Widget>[
                                _altoAncho(),
                                SizedBox( height: 20,),
                                _largoMadera(),
                                SizedBox( height: 20,),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            Container(
                                                width: 50,
                                                child: titleList('Si' ),
                                            ),
                                            Container(
                                                width: 50,
                                                child: titleList('No'),
                                            ),
                                        ],
                                    ),
                                ),
                                Divider(),                                
                                _podaList(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Container(
                                            width: 50,
                                            child: titleList('Alta')
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50,
                                            child: titleList('Media')
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50,
                                            child: titleList('Baja')
                                        ),
                                    ],
                                ),
                                
                                _produccion(),
                                Divider(),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30.0),
                                    child: _botonsubmit(tituloBtn)
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
                        initialValue: planta.altura == null ? '' : planta.altura.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            labelText: 'Altura en mt',
                            hintText: 'ejem: 3',
                        ),
                        maxLength: 5,
                        validator: (value) => utils.floatPositivo(value),
                        onSaved: (value) => planta.altura = double.parse(value!),
                    )
                ),
                SizedBox(width: 20.0,),
                Flexible(
                    child: TextFormField(
                        initialValue: planta.ancho == null ? '' : planta.ancho.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            labelText: 'Ancho en mt',
                            hintText: 'ejem: 3',
                        ),
                        maxLength: 5,
                        validator: (value) => utils.floatPositivo(value),
                        onSaved: (value) => planta.ancho = double.parse(value!),
                    )
                ),
            ],
        );
        
    }

    Widget _largoMadera(){

        return TextFormField(
            initialValue: planta.largo == null ? '' : planta.largo.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Largo de madera productiva',
                hintText: 'ejem: 3',
            ),
            maxLength: 5,
            validator: (value) => utils.floatPositivo(value),
            onSaved: (value) => planta.largo = double.parse(value!),
        );
        
    }
    
    

    Widget _podaList(){

        return ListView.builder(
            
            itemBuilder: (BuildContext context, int index) {
                
                String? labelPoda = itemPoda.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                int idPoda = int.parse(itemPoda.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "100","label": "No data"})['value']);
                                
                return Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                Expanded(child: textList('$labelPoda')),
                                Transform.scale(
                                    scale: 1.2,
                                    child: Radio(
                                        value: '1',
                                        groupValue: radios[itemPoda[idPoda]['value']],
                                        onChanged: (dynamic value){
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
                                        onChanged: (dynamic value){
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
                Expanded(child: textList('Producción')),
                Transform.scale(
                    scale: 1.2,
                    child: Radio(
                        value: 1,
                        groupValue: planta.produccion,
                        onChanged: (dynamic value) {
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
                        onChanged: (dynamic value) {
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
                        onChanged: (dynamic value) {
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

    

    Widget  _botonsubmit(String tituloBtn){
        return ButtonMainStyle(
            title: tituloBtn,
            icon: Icons.save,
            press:(_guardando) ? null : _submit,
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

        if  ( !formKey.currentState!.validate() ){
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
            mostrarSnackbar('Hay $variableVacias Campos Vacios, Favor llene todo los campos', context);
            return null;
        }

        formKey.currentState!.save();


        setState(() {_guardando = true;});

        
        if(planta.id == null){
            planta.id =  uuid.v1();
            _listaPodas();
            fincasBloc.addPlata(planta);

            listaPodas.forEach((item) {
                DBProvider.db.nuevoExistePodas(item);
            });

        }else{
            planta.id =  uuid.v1();
            _listaPodas();
            fincasBloc.actualizarPlata(planta);

            listaPodas.forEach((item) {
                DBProvider.db.nuevoExistePodas(item);
            });
        }
        mostrarSnackbar('Registro planta guardado', context);
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
       
        
    }


 


}