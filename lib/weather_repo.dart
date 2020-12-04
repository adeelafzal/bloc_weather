import 'package:bloc_weather/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WeatherRepo {
  Future<WeatherModel> getWeather(String city) async {
    final result = await http.Client().get(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=ea49455754783d7f9ac5ba9932093ea1&units=metric');
    if (result.statusCode != 200) throw Exception();
    return parseJson(result.body);
  }

  WeatherModel parseJson(final response) {
final jsonDecode = convert.jsonDecode(response);
final jsonWeather = jsonDecode['main'];
return WeatherModel.fromJson(jsonWeather);
  }

}
