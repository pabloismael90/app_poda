import 'package:app_poda/src/pages/PDFView.dart';
import 'package:app_poda/src/pages/decisiones/decisiones_form.dart';
import 'package:app_poda/src/pages/decisiones/decisiones_page.dart';
import 'package:app_poda/src/pages/decisiones/reporte_page.dart';
import 'package:app_poda/src/pages/estaciones/estaciones_page.dart';
import 'package:app_poda/src/pages/finca/finca_form.dart';
import 'package:app_poda/src/pages/finca/finca_page.dart';
import 'package:app_poda/src/pages/galeria/image.dart';
import 'package:app_poda/src/pages/galeria/list_galeria.dart';
import 'package:app_poda/src/pages/parcelas/parcela_form.dart';
import 'package:app_poda/src/pages/parcelas/parcelas_page.dart';
import 'package:app_poda/src/pages/estaciones/planta_form.dart';
import 'package:app_poda/src/pages/estaciones/planta_page.dart';
import 'package:app_poda/src/pages/testPoda/testpoda_form.dart';
import 'package:app_poda/src/pages/testPoda/testpoda_page.dart';
import 'package:app_poda/src/utils/constants.dart';
import 'package:flutter/material.dart';
 
import 'package:app_poda/src/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light, 
            )        
        );
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            
            localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
                const Locale('es', 'ES'),
                // const Locale('en', 'US'),
            ],
            title: 'Material App',
            initialRoute:'home',
            routes: {
                'home' : ( BuildContext context ) => HomePage(),
                //Finca
                'fincas' : ( BuildContext context ) => FincasPage(),
                'addFinca' : ( BuildContext context ) => AgregarFinca(),
                //Parcelas
                'parcelas' : ( BuildContext context ) => ParcelaPage(),
                'addParcela' : ( BuildContext context ) => AgregarParcela(),
                //test
                'tests' :  ( BuildContext context ) => TestPage(),
                'addTest' : ( BuildContext context ) => AgregarTest(),
                //estaciones
                'estaciones' : ( BuildContext context ) => EstacionesPage(),
                'plantas' : ( BuildContext context ) => PlantaPage(),
                'addPlanta' : ( BuildContext context ) => AgregarPlanta(),
                //Decisiones
                'decisiones' : ( BuildContext context ) => DesicionesPage(),
                'registros' : ( BuildContext context ) => DesicionesList(),
                'reporte' : ( BuildContext context ) => ReportePage(),
                //Galeria de imagenes
                'galeria' : ( BuildContext context ) => GaleriaImagenes(),
                'viewImg' : ( BuildContext context ) => ViewImage(),
                'PDFview' : ( BuildContext context ) => PDFView(),
                

            },
            theme: ThemeData(
                fontFamily: "Museo",
                scaffoldBackgroundColor: kBackgroundColor,
                primaryTextTheme: TextTheme(
                    headline6: TextStyle(
                    color: Colors.white
                    )
                ),
                textTheme: Theme.of(context).textTheme.apply(displayColor: kTextColor, fontFamily: 'Museo'),
                appBarTheme: AppBarTheme(color: kbase,brightness: Brightness.dark),
                primaryColor:kbase,
                primaryIconTheme: IconThemeData(color: Colors.white),
                inputDecorationTheme: InputDecorationTheme(
                    labelStyle: Theme.of(context).textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold, color: kTextColor, fontSize: 14, fontFamily: 'Museo'),
                ),
            
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        primary: Color(0xFF3f2a56),
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                        minimumSize: Size(88, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                        ),
                        

                    )
                )
                
            ),
             
             
            
        );
    }
}