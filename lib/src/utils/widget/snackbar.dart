import 'package:flutter/material.dart';

void mostrarSnackbar(String mensaje, BuildContext context){
    final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
}