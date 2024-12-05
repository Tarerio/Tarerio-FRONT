class Respuesta {
  String? respuesta;
  bool? realizado;

  Respuesta({this.respuesta, this.realizado});
}

class Enunciado {
  String? texto;
  String? imagen;
  String? video;
  Respuesta? respuesta;

  Enunciado({this.texto, this.imagen, this.video});
}
