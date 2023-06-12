import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/api_end_points.dart';

class ApiEdificiosService {
  Future<List<Edificio>> getEdificios() async {
    final response = await http.get(Uri.parse(allEdificiosURL));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Edificio> edificios = data.map((json) => Edificio.fromJson(json)).toList();
      return edificios;
    } else {
      throw Exception('Error al obtener los edificios');
    }
  }
}
