

bool isNumeric(String value){

    if (value.isEmpty){
        //print(value);
        return false;
    } 

    final numero = num.parse(value);
    // ignore: unnecessary_null_comparison
    return (numero == null ) ? false : true;
      
}


