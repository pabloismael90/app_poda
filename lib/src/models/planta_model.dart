class Planta {
    Planta({
        this.id,
        this.idTest,
        this.altura = 0.0,
        this.ancho = 0.0,
        this.largo = 0.0,
        this.estacion,
        this.produccion = 0,
    });

    String id;
    String idTest;
    double altura;
    double ancho;
    double largo;
    int estacion;
    int produccion;

    factory Planta.fromJson(Map<String, dynamic> json) => Planta(
        id: json["id"],
        idTest: json["idTest"],
        altura : json ['altura'],
        ancho : json ['ancho'],
        largo : json ['largo'],
        estacion: json["estacion"],
        produccion: json["produccion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "altura" : altura,
        "ancho" : ancho,
        "largo" : largo,
        "estacion": estacion,
        "produccion": produccion,
    };
}
