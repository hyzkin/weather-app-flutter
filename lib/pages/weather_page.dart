import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('YOUR API KEY');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? condition) {
    if (condition == null) {
      return "assets/weather/sunny.json";
    }

    switch (condition.toLowerCase()) {
      case 'clouds':
        return 'assets/weather/cloudy.json';
      case 'clear':
        return 'assets/weather/sunny.json';
      case 'rain':
        return 'assets/weather/rainy.json';
      case 'snow':
        return 'assets/weather/snowy.json';
      case "smoke":
        return 'assets/weather/mist.json';
      default:
        return 'assets/weather/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _weather?.cityName.toUpperCase() ??
                        "loading city".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily:
                            GoogleFonts.oswald(fontWeight: FontWeight.w500)
                                .fontFamily),
                  ),
                ],
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text(
                '${_weather?.temperature.round()}°',
                style: TextStyle(
                    fontSize: 48,
                    // fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: GoogleFonts.oswald(fontWeight: FontWeight.w500)
                        .fontFamily),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
