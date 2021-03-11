class Acciones {
    Acciones({
        this.id,
        this.idItem,
        this.repuesta,
        this.idTest,
    });

    String id;
    int idItem;
    String repuesta;
    String idTest;

    factory Acciones.fromJson(Map<String, dynamic> json) => Acciones(
        id: json["id"],
        idItem: json["idItem"],
        repuesta: json["repuesta"],
        idTest: json["idTest"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idItem": idItem,
        "repuesta": repuesta,
        "idTest": idTest,
    };
}