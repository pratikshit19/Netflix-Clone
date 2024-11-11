import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<List<dynamic>> fetchMovies(String query) async {
    var url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
