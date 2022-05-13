import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stopwatch_flutter/ui/elapsed_time_text.dart';
import 'package:stopwatch_flutter/ui/elapsed_time_text_basic.dart';
import 'package:stopwatch_flutter/ui/reset_button.dart';
import 'package:stopwatch_flutter/ui/start_stop_button.dart';
import 'package:stopwatch_flutter/ui/stopwatch_renderer.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch>
    with SingleTickerProviderStateMixin {
  Duration _previouslyElasped = Duration.zero;
  Duration _currentlyElasped = Duration.zero;
  bool _isRunning = false;
  late final Ticker _ticker;
  Duration get _elasped => _previouslyElasped + _currentlyElasped;
  @override
  void initState() {
    super.initState();

    _ticker = this.createTicker((elapsed) {
      setState(() {
        _currentlyElasped = elapsed;
      });
    });
    //_ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _ticker.start();
      } else {
        _ticker.stop();
        _previouslyElasped += _currentlyElasped;
        _currentlyElasped = Duration.zero;
      }
    });
  }
 void _reset() {
     _ticker.stop();
    setState(() {
      
      _isRunning = false;
        _previouslyElasped    = Duration.zero;
           _currentlyElasped = Duration.zero;
     
    });
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain) {
      final radius = constrain.maxWidth / 2;
      return Stack(
        children: [
          StopWatchRenderer(
            elapsed: _elasped,
            radius: radius,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 80,
              height: 80,
              child: ResetButton(
                onPressed: _reset,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 80,
              height: 80,
              child: StartStopButton(
                  isRunning: _isRunning, onPressed: _toggleRunning),
            ),
          )
        ],
      );
    });
  }
}
