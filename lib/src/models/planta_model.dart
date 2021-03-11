class Planta {
    Planta({
        this.id,
        this.idTest,
        this.estacion,
        this.produccion = 0,
    });

    String id;
    String idTest;
    int estacion;
    int produccion;

    factory Planta.fromJson(Map<String, dynamic> json) => Planta(
        id: json["id"],
        idTest: json["idTest"],
        estacion: json["estacion"],
        produccion: json["produccion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "estacion": estacion,
        "produccion": produccion,
    };
}
