class WeatherModel {
  final temp, pressure, humidity, temp_max, temp_min;

  double get getTemp => temp;
  double get getpressure => pressure;
  double get getHumidity=> humidity;

  WeatherModel(
    this.temp,
    this.pressure,
    this.humidity,
    this.temp_max,
    this.temp_min,
  );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      json['temp'],
      json['pressure'],
      json['humidity'],
      json['temp_max'],
      json['temp_min'],
    );
  }
}
