import 'package:bloc_weather/weather_bloc.dart';
import 'package:bloc_weather/weather_model.dart';
import 'package:bloc_weather/weather_repo.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
          create: (BuildContext context) {
            return WeatherBloc(isNotSearched(), WeatherRepo());
          },
          child: SearchPage()),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xff5dbcd2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            child: FlareActor(
              "images/WorldSpin.flr",
              fit: BoxFit.contain,
              animation: "roll",
            ),
            height: 300,
            width: 300,
          )),
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is isNotSearched) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        'Search Weather',
                        style: TextStyle(fontSize: 40),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: cityController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'City Name',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is isLoadingSearched) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is isLoadedSearched) {
                return ShowWeather(state.getWeather, cityController.text);
              }
              return Center(
                  child: Text(
                'Error',
                style: TextStyle(fontSize: 40, color: Colors.red),
              ));
            },
          )
        ],
      ),
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(
              city,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weather.getTemp.round().toString() + "C",
              style: TextStyle(color: Colors.white70, fontSize: 50),
            ),
            Text(
              "Temprature",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weather.getHumidity.toString(),
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Humidity",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      weather.getpressure.toString(),
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Pressure",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                },
                color: Colors.lightBlue,
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
