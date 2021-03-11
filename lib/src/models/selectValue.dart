List<Map<String, dynamic>> dimenciones(){

    
    final List<Map<String, dynamic>> medidaItem = [
            {
                'value': '1',
                'label': 'Mz',
                
            },
            {
                'value': '2',
                'label': 'Ha',
            },
    ];

    return medidaItem;
}

List<Map<String, dynamic>> listMeses(){

    
    final List<Map<String, dynamic>> medidaItem = [
        {
            'value': '1',
            'label': 'Enero',
        },
        {
            'value': '2',
            'label': 'Febrero',
        },
        {
            'value': '3',
            'label': 'Marzo',
        },
        {
            'value': '4',
            'label': 'Abril',
        },
        {
            'value': '5',
            'label': 'Mayo',
        },
        {
            'value': '6',
            'label': 'Junio',
        },
        {
            'value': '7',
            'label': 'Julio',
        },
        {
            'value': '8',
            'label': 'Agosto',
        },
        {
            'value': '9',
            'label': 'Septiembre',
        },
        {
            'value': '10',
            'label': 'Octubre',
        },
        {
            'value': '11',
            'label': 'Noviembre',
        },
        {
            'value': '12',
            'label': 'Diciembre',
        },
    ];

    return medidaItem;
}


List<Map<String, dynamic>> variedadCacao(){
    final List<Map<String, dynamic>>  variedadesCacao = [
            {
                'value': '1', 
                'label': 'CAT 1'
            },
            {
                'value': '2', 
                'label': 'CAT 2'
            },
            {
                'value': '3', 
                'label': 'CAT 3'
            },
            {
                'value': '3', 
                'label': 'CAT 3'
            },
            {
                'value': '4', 
                'label': 'CAT 4'
            },
            {
                'value': '5', 
                'label': 'CAT 5'
            },
        ];

    return variedadesCacao;
}

List<Map<String, dynamic>> podaCacao(){
    final List<Map<String, dynamic>>  plagasCacao = [
            {
                'value': '0', 
                'label': 'Buena arquitectura'
            },
            {
                'value': '1', 
                'label': 'Ramas en contacto'
            },
            {
                'value': '2', 
                'label': 'Ramas entrecruzados'
            },
            {
                'value': '3', 
                'label': 'Ramas cercanas al suelo'
            },
            {
                'value': '4', 
                'label': 'Chupones'
            },
            {
                'value': '5', 
                'label': 'Entrada de luz'
            }

        ];

    return plagasCacao;
}








List<Map<String, dynamic>> situacionPlaga(){
    final List<Map<String, dynamic>>  situacionPlaga = [
        {
            'value': '0',
            'label': 'Varias plagas en todos los puntos'
        },
        {
            'value': '1',
            'label': 'Varias plagas en algunos puntos'
        },
        {
            'value': '2',
            'label': 'Pocas plagas en todos los puntos'
        },
        {
            'value': '3',
            'label': 'Pocas plagas en algunos puntos'
        },
        {
            'value': '4',
            'label': 'Una plaga en todos los puntos'
        },
        {
            'value': '5',
            'label': 'Una plaga en algunos puntos'
        }

    ];

    return situacionPlaga;
}
List<Map<String, dynamic>> problemasPlagaSuelo(){
    final List<Map<String, dynamic>>  problemasSuelo = [
        {
            'value': '0',
            'label': 'Suelo erosionado'
        },
        {
            'value': '1',
            'label': 'Suelo poco fértil'
        },
        {
            'value': '2',
            'label': 'Mucha competencia'
        },
        {
            'value': '3',
            'label': 'Mal drenaje'
        },
        {
            'value': '4',
            'label': 'Falta obras de conservación'
        },
        {
            'value': '5',
            'label': 'Suelo compacto'
        },
        {
            'value': '6',
            'label': 'Suelo con poca MO'
        },
        {
            'value': '7',
            'label': 'No usa abono o fertilizante'
        }

    ];

    return problemasSuelo;
}
List<Map<String, dynamic>> problemasPlagaSombra(){
    final List<Map<String, dynamic>>  problemasSombra = [
        {
            'value': '0',
            'label': 'Sombra muy densa'
        },
        {
            'value': '1',
            'label': 'Sombra muy rala'
        },
        {
            'value': '2',
            'label': 'Sombra mal distribuida'
        },
        {
            'value': '3',
            'label': 'Arboles de sombra no adecuada'
        },
        {
            'value': '4',
            'label': 'Mucha auto-sombra'
        },
        {
            'value': '5',
            'label': 'Mucho banano'
        }

    ];

    return problemasSombra;
}
List<Map<String, dynamic>> problemasPlagaManejo(){
    final List<Map<String, dynamic>>  problemasManejo = [
        {
            'value': '0',
            'label': 'Poda no adecuada'
        },
        {
            'value': '1',
            'label': 'Piso no manejado'
        },
        {
            'value': '2',
            'label': 'No eliminan mazorcas enfermas'
        },
        {
            'value': '3',
            'label': 'No hay manejo de plagas'
        },
        {
            'value': '4',
            'label': 'Plantas desnutridas'
        },
        {
            'value': '5',
            'label': 'Plantación vieja'
        },
        {
            'value': '6',
            'label': 'Variedades susceptibles'
        },
        {
            'value': '7',
            'label': 'Variedades no productivas'
        }

    ];

    return problemasManejo;
}
List<Map<String, dynamic>> solucionesXmes(){
    final List<Map<String, dynamic>>  solucionesXmes = [
        {
            'value': '0',
            'label': 'Recuento de plagas'
        },
        {
            'value': '1',
            'label': 'Cortar las mazorcas enfermas'
        },
        {
            'value': '2',
            'label': 'Abonar las plantas'
        },
        {
            'value': '3',
            'label': 'Aplicar Caldos'
        },
        {
            'value': '4',
            'label': 'Aplicar Fungicidas'
        },
        {
            'value': '5',
            'label': 'Manejo de sombra'
        },
        {
            'value': '6',
            'label': 'Podar las plantas de cacao'
        },
        {
            'value': '7',
            'label': 'Aplicar venenos para Zompopo'
        },
        {
            'value': '8',
            'label': 'Control de Comején'
        }

    ];

    return solucionesXmes;
}



















