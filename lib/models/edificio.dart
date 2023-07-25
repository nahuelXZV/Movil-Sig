
class Edificio {
    String? id;
    String? createdAt;
    String? updatedAt;
    int? fid;
    String? descripcion;
    int? codEdif;
    double? latitud;
    double? longitud;
    String? grupo;
    String? sigla;
    String? localidad;


  Edificio(
    {
      this.id,
      this.createdAt,
      this.updatedAt,
      this.fid,
      this.descripcion,
      this.codEdif,
      this.latitud,
      this.longitud,
      this.grupo,
      this.sigla,
      this.localidad,
    }
  );

  factory Edificio.fromJson(Map<String, dynamic> json) {
    return Edificio(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      fid: json['fid'],
      descripcion: json['descripcion'],
      codEdif: json['codEdif'],
      latitud: double.parse(json['latitud']),
      longitud: double.parse(json['longitud']),
      grupo: json['grupo'],
      sigla: json['sigla'],
      localidad: json['localidad'],
    );
  }
}