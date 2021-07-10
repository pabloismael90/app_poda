import 'dart:async';
import 'dart:io';

import 'package:app_poda/src/models/decisiones_model.dart';
import 'package:app_poda/src/models/existePoda_model.dart';
import 'package:app_poda/src/models/planta_model.dart';
import 'package:app_poda/src/models/testpoda_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


import 'package:app_poda/src/models/finca_model.dart';
export 'package:app_poda/src/models/finca_model.dart';
import 'package:app_poda/src/models/parcela_model.dart';
export 'package:app_poda/src/models/parcela_model.dart';

class DBProvider {

    static Database? _database; 
    static final DBProvider db = DBProvider._();

    DBProvider._();

    Future<Database?> get database async {

        if ( _database != null ) return _database;

        _database = await initDB();
        return _database;
    }

    initDB() async {

        Directory documentsDirectory = await getApplicationDocumentsDirectory();

        final path = join( documentsDirectory.path, 'poda.db' );

        print(path);

        return await openDatabase(
            path,
            version: 1,
            onOpen: (db) {},
            onConfigure: _onConfigure,
            onCreate: ( Database db, int version ) async {
                await db.execute(
                    'CREATE TABLE Finca ('
                    ' id TEXT PRIMARY KEY,'
                    ' nombreFinca TEXT,'
                    ' nombreProductor TEXT,'
                    ' areaFinca REAL,'
                    ' tipoMedida INTEGER,'
                    ' nombreTecnico TEXT'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Parcela ('
                    ' id TEXT PRIMARY KEY,'
                    ' idFinca TEXT,'
                    ' nombreLote TEXT,'
                    ' areaLote REAL,'
                    ' variedadCacao INTEGER,'
                    ' numeroPlanta INTEGER,'
                    'CONSTRAINT fk_parcela FOREIGN KEY(idFinca) REFERENCES Finca(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE TestPoda ('
                    ' id TEXT PRIMARY KEY,'
                    ' idFinca TEXT,'
                    ' idLote TEXT,'
                    ' estaciones INTEGER,'
                    ' fechaTest TEXT,'
                    ' CONSTRAINT fk_fincaTest FOREIGN KEY(idFinca) REFERENCES Finca(id) ON DELETE CASCADE,'
                    ' CONSTRAINT fk_parcelaTest FOREIGN KEY(idLote) REFERENCES Parcela(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Planta ('
                    'id TEXT PRIMARY KEY,'
                    ' idTest TEXT,'
                    ' altura REAL,'
                    ' ancho REAL,'
                    ' largo REAL,'
                    ' estacion INTEGER,'
                    ' produccion INTEGER,'
                    ' CONSTRAINT fk_TestPoda FOREIGN KEY(idTest) REFERENCES TestPoda(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE ExistePoda ('
                    'id TEXT PRIMARY KEY,'
                    ' idPlaga INTEGER,'
                    ' idPlanta INTEGER,'
                    ' existe INTEGER,'
                    ' CONSTRAINT fk_existePoda FOREIGN KEY(idPlanta) REFERENCES Planta(id) ON DELETE CASCADE'
                    ')'
                );


                await db.execute(
                    'CREATE TABLE Decisiones ('
                    'id TEXT PRIMARY KEY,'
                    ' idPregunta INTEGER,'
                    ' idItem INTEGER,'
                    ' repuesta INTEGER,'
                    ' idTest TEXT,'
                    ' CONSTRAINT fk_decisiones FOREIGN KEY(idTest) REFERENCES TestPoda(id) ON DELETE CASCADE'
                    ')'
                );
            }
        
        );

    }

    static Future _onConfigure(Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
    }

    

    //ingresar Registros
    nuevoFinca( Finca nuevaFinca ) async {
        final db  = await (database);
        final res = await db!.insert('Finca',  nuevaFinca.toJson() );
        return res;
    }

    nuevoParcela( Parcela nuevaParcela ) async {
        final db  = await (database);
        final res = await db!.insert('Parcela',  nuevaParcela.toJson() );
        return res;
    }

    nuevoTestPoda( TestPoda nuevaPlaga ) async {
        final db  = await (database);
        final res = await db!.insert('TestPoda',  nuevaPlaga.toJson() );
        return res;
    }

    nuevoPlanta( Planta nuevaPlanta ) async {
        final db  = await (database);
        final res = await db!.insert('Planta',  nuevaPlanta.toJson() );
        return res;
    }

    nuevoExistePodas( ExistePoda existePoda ) async {
        final db  = await (database);
        final res = await db!.insert('ExistePoda',  existePoda.toJson() );
        return res;
    }

    nuevaDecision( Decisiones decisiones ) async {
        final db  = await (database);
        final res = await db!.insert('Decisiones',  decisiones.toJson() );
        return res;
    }



    
    
    //Obtener registros
    Future<List<Finca>> getTodasFincas() async {

        final db  = await (database);
        final res = await db!.query('Finca');

        List<Finca> list = res.isNotEmpty 
                                ? res.map( (c) => Finca.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Parcela>> getTodasParcelas() async {

        final db  = await (database);
        final res = await db!.query('Parcela');

        List<Parcela> list = res.isNotEmpty 
                                ? res.map( (c) => Parcela.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<TestPoda>> getTodasTestPoda() async {

        final db  = await (database);
        final res = await db!.query('TestPoda');

        List<TestPoda> list = res.isNotEmpty 
                                ? res.map( (c) => TestPoda.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Planta>> getTodasPlantas() async {

        final db  = await (database);
        final res = await db!.query('Planta');

        List<Planta> list = res.isNotEmpty 
                                ? res.map( (c) => Planta.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<int?> countPlanta(String idTest,  int estacion ) async {

        final db = await (database);
        int? count = Sqflite.firstIntValue(await db!.rawQuery("SELECT COUNT(*) FROM Planta WHERE idTest = '$idTest' AND estacion = '$estacion'"));
        return count;
    

    }

    Future<List<Decisiones>> getTodasDesiciones() async {

        final db  = await (database);
        final res = await db!.rawQuery('SELECT DISTINCT idTest FROM Decisiones');

        List<Decisiones> list = res.isNotEmpty 
                                ? res.map( (c) => Decisiones.fromJson(c) ).toList()
                                : [];
        return list;
    }


    
    
    //REgistros por id
    Future<Finca?> getFincaId(String? id) async{
        final db = await (database);
        final res = await db!.query('Finca', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Finca.fromJson(res.first) : null;
    }

    Future<Parcela?> getParcelaId(String? id) async{
        final db = await (database);
        final res = await db!.query('Parcela', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Parcela.fromJson(res.first) : null;
    }

    Future<TestPoda?> getTestId(String? id) async{
        final db = await (database);
        final res = await db!.query('TestPoda', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? TestPoda.fromJson(res.first) : null;
    }

    Future<List<Parcela>> getTodasParcelasIdFinca(String? idFinca) async{

        final db = await (database);
        final res = await db!.query('Parcela', where: 'idFinca = ?', whereArgs: [idFinca]);
        List<Parcela> list = res.isNotEmpty 
                    ? res.map( (c) => Parcela.fromJson(c) ).toList() 
                    : [];
        
        return list;            
    }

    Future<List<Planta>> getTodasPlantaIdTest(String? idTest) async{
        final db = await (database);
        final res = await db!.query('Planta', where: 'idTest = ?', whereArgs: [idTest]);
        List<Planta> list = res.isNotEmpty 
                    ? res.map( (c) => Planta.fromJson(c) ).toList() 
                    : [];
        return list;            
    }
   
    Future<List<Planta>> getTodasPlantasIdTest(String? idTest, int? estacion) async{
        final db = await (database);
        final res = await db!.rawQuery("SELECT * FROM Planta WHERE idTest = '$idTest' AND estacion = '$estacion'");
        //final res = await db!.query('Planta', where: 'idTest = ?', whereArgs: [idTest]);
        List<Planta> list = res.isNotEmpty 
                    ? res.map( (c) => Planta.fromJson(c) ).toList() 
                    : [];

        return list;           
    }

    Future<List<ExistePoda>> getTodasPlagasIdPlanta(String idPlanta) async {

        final db  = await (database);
        final res = await db!.rawQuery("SELECT * FROM ExistePoda WHERE idPlanta = '$idPlanta'");

        List<ExistePoda> list = res.isNotEmpty 
                    ? res.map( (c) => ExistePoda.fromJson(c) ).toList() 
                    : [];
        return list;
    }

    Future<int?> getPlagasIdPlanta(String idPlanta, int idplaga) async {
        
        final db  = await (database);
        String query = "SELECT existe FROM ExistePoda WHERE idPlanta = '$idPlanta' AND idPlaga = '$idplaga'";
        final  res = await db!.rawQuery(query);
        int? value = (res.isNotEmpty ? res[0]['existe'] : -1) as int?;

        return value;
    }

    Future<List<Decisiones>> getDecisionesIdTest(String? idTest) async{
        final db = await (database);
        final res = await db!.query('Decisiones', where: 'idTest = ?', whereArgs: [idTest]);
        List<Decisiones> list = res.isNotEmpty 
                                ? res.map( (c) => Decisiones.fromJson(c) ).toList()
                                : [];
        return list;
    }




    //List Select
    Future<List<Map<String, dynamic>>> getSelectFinca() async {
       
        final db  = await (database);
        final res = await db!.rawQuery(
            "SELECT id AS value, nombreFinca AS label FROM Finca"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        return list; 
    }
    
    Future<List<Map<String, dynamic>>> getSelectParcelasIdFinca(String idFinca) async{
        final db = await (database);
        final res = await db!.rawQuery(
            "SELECT id AS value, nombreLote AS label FROM Parcela WHERE idFinca = '$idFinca'"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        return list;
                    
    }


    // Actualizar Registros
    Future<int> updateFinca( Finca nuevaFinca ) async {

        final db  = await (database);
        final res = await db!.update('Finca', nuevaFinca.toJson(), where: 'id = ?', whereArgs: [nuevaFinca.id] );
        return res;

    }

    Future<int> updateParcela( Parcela nuevaParcela ) async {

        final db  = await (database);
        final res = await db!.update('Parcela', nuevaParcela.toJson(), where: 'id = ?', whereArgs: [nuevaParcela.id] );
        return res;

    }

    Future<int> updateTestPoda( TestPoda nuevaPlaga ) async {

        final db  = await (database);
        final res = await db!.update('TestPoda', nuevaPlaga.toJson(), where: 'id = ?', whereArgs: [nuevaPlaga.id] );
        return res;

    }

    Future<int> updatePlanta( Planta nuevaPlanta ) async {

        final db  = await (database);
        final res = await db!.update('Planta', nuevaPlanta.toJson(), where: 'id = ?', whereArgs: [nuevaPlanta.id] );
        return res;

    }


    //Conteos analisis
    Future<double?> countPlagaEstacion( String? idTest, int estacion, int idPlaga) async {

        final db = await (database);
        String query =  "SELECT COUNT(*) FROM TestPoda "+
                        "INNER JOIN Planta ON TestPoda.id = Planta.idTest " +
                        "INNER JOIN ExistePoda ON  Planta.id = ExistePoda.idPlanta " +
                        "WHERE idTest = '$idTest' AND estacion = '$estacion' AND idPlaga = '$idPlaga' AND existe = 1";
        int? res = Sqflite.firstIntValue(await db!.rawQuery(query));
        double? value = res!/10;
        return value;

    }

    Future<double> countPlagaTotal( String? idTest, int idPlaga) async {

        final db = await (database);
        String query =  "SELECT COUNT(*) FROM TestPoda "+
                        "INNER JOIN Planta ON TestPoda.id = Planta.idTest " +
                        "INNER JOIN ExistePoda ON  Planta.id = ExistePoda.idPlanta " +
                        "WHERE idTest = '$idTest' AND idPlaga = '$idPlaga' AND existe = 1";
        int? res = Sqflite.firstIntValue(await db!.rawQuery(query));
        double value = res!/30;
        return value;

    }

    Future<double> countAlturaEstacion( String? idTest, int estacion) async {

        final db = await (database);
        String query =  "SELECT SUM(altura) FROM Planta WHERE idTest = '$idTest' AND estacion = '$estacion'";
        var res = await db!.rawQuery(query);
        double? value = res[0]['SUM(altura)'] as double?;
        if (value == null) {
            return 0;
        }
        return value/10;

    }

    Future<double> countAlturaTotal( String? idTest ) async {

        final db = await (database);
        String query =  "SELECT SUM(altura) FROM Planta WHERE idTest = '$idTest'";
        var res = await db!.rawQuery(query);
        double? value = res[0]['SUM(altura)'] as double?;
        if (value == null) {
            return 0;
        }
        return value/30;

    }

    Future<double> countAnchoEstacion( String? idTest, int estacion) async {

        final db = await (database);
        String query =  "SELECT SUM(ancho) FROM Planta WHERE idTest = '$idTest' AND estacion = '$estacion'";
        var res = await db!.rawQuery(query);
        double? value = res[0]['SUM(ancho)'] as double?;
        if (value == null) {
            return 0;
        }
        return value/10;

    }

    Future<double> countAnchoTotal( String? idTest ) async {

        final db = await (database);
        String query =  "SELECT SUM(ancho) FROM Planta WHERE idTest = '$idTest'";
        var res = await db!.rawQuery(query);
        double? value = res[0]['SUM(ancho)'] as double?;
        if (value == null) {
            return 0;
        }
        return value/30;

    }

    Future<double> countLargoEstacion( String? idTest, int estacion) async {

        final db = await (database);
        String query =  "SELECT SUM(largo) FROM Planta WHERE idTest = '$idTest' AND estacion = '$estacion'";
        var res = await db!.rawQuery(query);
        double? value = res[0]['SUM(largo)'] as double?;
        if (value == null) {
            return 0;
        }
        return value/10;

    }

    Future<double> countLargoTotal( String? idTest ) async {

        final db = await (database);
        String query =  "SELECT SUM(largo) FROM Planta WHERE idTest = '$idTest'";
        var res = await db!.rawQuery(query);
        double? value = res[0]['SUM(largo)'] as double?;
        if (value == null) {
            return 0;
        }
        return value/30;

    }

    Future<double> countProduccion( String? idTest, int estacion, int estado) async {

        final db = await (database);
        String query =  "SELECT COUNT(*) FROM Planta WHERE idTest = '$idTest' AND estacion = '$estacion' AND produccion = '$estado'";
        int? res = Sqflite.firstIntValue(await db!.rawQuery(query));
        double value = res!/10;
        return value;

    }

    Future<double> countTotalProduccion( String? idTest, int estado ) async {

        final db = await (database);
        String query =  "SELECT COUNT(*) FROM Planta WHERE idTest = '$idTest' AND produccion = '$estado'";
        int? res = Sqflite.firstIntValue(await db!.rawQuery(query));
        double value = res!/30;
        return value;

    }

    // Eliminar registros
    Future<int> deleteFinca( String? idFinca ) async {

        final db  = await (database);
        final res = await db!.delete('Finca', where: 'id = ?', whereArgs: [idFinca]);
        return res;
    }
    Future<int> deleteParcela( String? idParcela ) async {

        final db  = await (database);
        final res = await db!.delete('Parcela', where: 'id = ?', whereArgs: [idParcela]);
        return res;
    }

    Future<int> deleteTestPoda( String? idTest ) async {

        final db  = await (database);
        final res = await db!.delete('TestPoda', where: 'id = ?', whereArgs: [idTest]);
        return res;
    }

    Future<int> deletePlanta( String? idPlanta ) async {

        final db  = await (database);
        final res = await db!.delete('Planta', where: 'id = ?', whereArgs: [idPlanta]);
        return res;
    }


}