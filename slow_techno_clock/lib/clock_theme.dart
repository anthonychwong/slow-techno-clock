import 'dart:ui';

import 'package:flutter/foundation.dart';

class ClockTheme {
  final Color foreground;
  final Color background;
  final double digitGlow;
  final double iconGlow;

  ClockTheme(
      {@required this.foreground,
      @required this.background,
      @required this.digitGlow,
      @required this.iconGlow});
}
