import 'dart:convert';

TestPoda testPodaFromJson(String str) => TestPoda.fromJson(json.decode(str));

String testPodaToJson(TestPoda data) => json.encode(data.toJson());

class TestPoda {
    TestPoda({
        this.id,
        this.idFinca = '',
        this.idLote = '',
        this.estaciones = 3,
        this.fechaTest,
    });

    String id;
    String idFinca;
    String idLote;
    int estaciones;
    String fechaTest;

    factory TestPoda.fromJson(Map<String, dynamic> json) => TestPoda(
        id: json["id"],
        idFinca: json["idFinca"],
        idLote: json["idLote"],
        estaciones: json["estaciones"],
        fechaTest: json["fechaTest"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idFinca": idFinca,
        "idLote": idLote,
        "estaciones": estaciones,
        "fechaTest": fechaTest,
    };
}