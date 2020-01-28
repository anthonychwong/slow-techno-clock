// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:digital_clock/trapezoid_border.dart';
import 'package:digital_clock/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

import 'clock_background_painter.dart';
import 'clock_theme.dart';

final _lightTheme = ClockTheme(
    foreground: Colors.lightBlueAccent,
    background: Colors.white,
    digitGlow: 25,
    iconGlow: 40);

final _darkTheme = ClockTheme(
    foreground: Colors.lightBlueAccent,
    background: Colors.black,
    digitGlow: 25,
    iconGlow: 35);

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  Widget _twoDigitWrap(String twoDigitString, Size size) {
    return SizedBox.fromSize(
        size: size,
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(
              child: Text(
            twoDigitString.substring(0, 1),
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            twoDigitString.substring(1),
            textAlign: TextAlign.center,
          ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final clockTheme = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final date = DateFormat('yyyy MMM dd EEE').format(_dateTime);
    final temperature =
        ('${widget.model.low.toStringAsFixed(1)} - ${widget.model.highString}');

    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    final fontSize = MediaQuery.of(context).size.width / 4;
    final clockHeight = MediaQuery.of(context).size.width * 3 / 5;
    final fontHeight = 131.0;

    // height positions of digits
    final heightOffset = 16.0;

    final minHeight = heightOffset;
    final maxHeight = (clockHeight - fontHeight) - heightOffset;

    final hrHeight = (maxHeight - minHeight) * _dateTime.hour / 24 + minHeight;
    final minsHeight =
        (maxHeight - minHeight) * _dateTime.minute / 60 + minHeight;

    final boxShadows = [
      BoxShadow(
        blurRadius: clockTheme.iconGlow,
        color: clockTheme.foreground,
        offset: Offset(0, 0),
      ),
    ];

    final defaultStyle = TextStyle(
      color: clockTheme.foreground,
      fontFamily: 'Audiowide',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: clockTheme.digitGlow,
          color: clockTheme.foreground,
          offset: Offset(0, 0),
        ),
      ],
    );

    return ClipRect(
      child: Container(
        color: clockTheme.background,
        child: Center(
          child: DefaultTextStyle(
            style: defaultStyle,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, -0.002)
                      ..rotateX(pi / 4),
                    alignment: Alignment.center,
                    child: CustomPaint(
                      painter: ClockBackgroundPainter(clockTheme.foreground),
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: hrHeight,
                    child: _twoDigitWrap(
                        hour,
                        Size(MediaQuery.of(context).size.width / 2,
                            fontHeight))),
                Positioned(
                    right: 0,
                    top: minsHeight,
                    child: _twoDigitWrap(
                        minute,
                        Size(MediaQuery.of(context).size.width / 2,
                            fontHeight))),
                Align(
                  alignment: Alignment.topCenter,
                  child: CustomPaint(
                    painter: TrapezoidPaint(
                        snapTo: SnapTo.top,
                        backgroundPaint: Paint()
                          ..color = clockTheme.background.withAlpha(150),
                        borderPaint: Paint()
                          ..color = clockTheme.foreground
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: defaultStyle.copyWith(fontSize: 24),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomPaint(
                    painter: TrapezoidPaint(
                        snapTo: SnapTo.bottom,
                        backgroundPaint: Paint()
                          ..color = clockTheme.background.withAlpha(150),
                        borderPaint: Paint()
                          ..color = clockTheme.foreground
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4.0),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WeatherIcon(
                          condition: widget.model.weatherCondition,
                          color: clockTheme.foreground,
                          boxShadows: boxShadows,
                        ),
                        Text(
                          temperature,
                          textAlign: TextAlign.center,
                          style: defaultStyle.copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
