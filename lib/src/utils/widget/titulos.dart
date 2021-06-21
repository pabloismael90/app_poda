import 'package:flutter/material.dart';

import '../constants.dart';

class TitulosPages  extends StatelessWidget {
    final String? titulo;
    const TitulosPages({
        Key? key,
        this.titulo,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(top:0, bottom: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                        child: Text(
                            titulo!,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                    ),
                    Row(
                        children: List.generate(
                            150~/2, (index) => Expanded(
                                child: Container(
                                    color: index%2==0?Colors.transparent
                                    :kShadowColor2,
                                    height: 2,
                                ),
                            )
                        ),
                    ),
                ],
            ),
        );
        
        
        
    }
}






