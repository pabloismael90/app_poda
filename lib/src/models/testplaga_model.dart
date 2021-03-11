import 'dart:convert';

Testplaga testplagaFromJson(String str) => Testplaga.fromJson(json.decode(str));

String testplagaToJson(Testplaga data) => json.encode(data.toJson());

class Testplaga {
    Testplaga({
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

    factory Testplaga.fromJson(Map<String, dynamic> json) => Testplaga(
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