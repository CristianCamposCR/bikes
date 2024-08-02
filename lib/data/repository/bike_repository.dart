import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bike_model.dart';

class BikeRepository{
  final String apiUrl;

  BikeRepository({required this.apiUrl});

  Future<List<BikeModel>> getBikes() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] != null && jsonResponse['data']['items'] != null) {
        List<dynamic> items = jsonResponse['data']['items'];
        List<BikeModel> bikes = items.map((dynamic item) => BikeModel.fromJson(item)).toList();
        return bikes;
      } else {
        throw Exception('Invalid response structure');
      }
    } else {
      throw Exception('Failed to load bikes: ${response.statusCode}');
    }
  }

  Future<BikeModel> createBike(BikeModel bike) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bike.toJson()),
    );
    if(response.statusCode == 201){
      return BikeModel.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to create bike';
    }
  }
  Future<BikeModel> updateBike(BikeModel bike) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${bike.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bike.toJson()),
    );
    if(response.statusCode == 200){
      return BikeModel.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to update bike';
    }
  }
  Future<void> deleteBike(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final statusCode = response.statusCode.toInt();
    print(statusCode);
    print(response.statusCode);
    if(statusCode != 200){
      throw 'Failed to delete bike';
    }
    return;
  }
}