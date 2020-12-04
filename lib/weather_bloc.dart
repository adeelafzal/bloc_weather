import 'package:bloc_weather/weather_model.dart';
import 'package:bloc_weather/weather_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final _city;

  FetchWeather(this._city);

  @override
  List<Object> get props => [_city];
}

class ResetWeather extends WeatherEvent {}

class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class isNotSearched extends WeatherState {}

class isLoadingSearched extends WeatherState {}

class isLoadedSearched extends WeatherState {
  final _weather;

  isLoadedSearched(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class isNotLoaded extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepo weatherRepo;

  WeatherBloc(WeatherState initialState, this.weatherRepo)
      : super(initialState);

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield isLoadingSearched();
      try {
        WeatherModel weather = await weatherRepo.getWeather(event._city);
        yield isLoadedSearched(weather);
      } catch (_) {
        yield isNotLoaded();
      }
    }else if (event is ResetWeather) {
      yield isNotSearched();
    }
  }
}
