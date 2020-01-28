import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIcon extends StatelessWidget {
  final WeatherCondition condition;
  final Color color;
  final List<BoxShadow> boxShadows;

  const WeatherIcon({Key key, this.condition, this.color, this.boxShadows})
      : super(key: key);

  IconData _getIconData(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.cloudy:
        return WeatherIcons.cloudy;
      case WeatherCondition.foggy:
        return WeatherIcons.fog;
      case WeatherCondition.rainy:
        return WeatherIcons.rain;
      case WeatherCondition.snowy:
        return WeatherIcons.snow;
      case WeatherCondition.sunny:
        return WeatherIcons.day_sunny;
      case WeatherCondition.thunderstorm:
        return WeatherIcons.thunderstorm;
      case WeatherCondition.windy:
        return WeatherIcons.windy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: boxShadows),
        child: BoxedIcon(
          _getIconData(condition),
          size: 20,
          color: color,
        ));
  }
}
