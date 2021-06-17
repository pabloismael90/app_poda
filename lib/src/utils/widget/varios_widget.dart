import 'package:flutter/material.dart';
import '../constants.dart';

void mostrarSnackbar(String mensaje, BuildContext context){
    final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Widget botonesBottom(Widget widget){
    return BottomAppBar(
        elevation: 0,
        child: Container(
            decoration: BoxDecoration(boxShadow: [
                BoxShadow(blurRadius: 0, color: kBackgroundColor)
            ]),
            child: widget
        ),
    );
}

Widget cardDefault(Widget widget){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                    BoxShadow(
                            color: Color(0xFF3A5160)
                                .withOpacity(0.05),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 17.0),
                    ],
            ),
            child: widget
    );
}