class ExistePoda {
    ExistePoda({
        this.id,
        this.idPlaga,
        this.idPlanta,
        this.existe = 1,
    });

    String? id;
    int? idPlaga;
    String? idPlanta;
    int? existe;

    factory ExistePoda.fromJson(Map<String, dynamic> json) => ExistePoda(
        id: json["id"],
        idPlaga: json["idPlaga"],
        idPlanta: json["idPlanta"],
        existe: json["existe"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idPlaga":idPlaga,
        "idPlanta": idPlanta,
        "existe": existe,
    };
}