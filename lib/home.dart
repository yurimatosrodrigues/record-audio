import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:record/record.dart';
import 'package:record_audio/list-audio.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false, isPaused = false, isPlaying = false;

  Widget _buildBackIcon() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      iconSize: 60,
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Audio will be lost'),
                content: Text('Are you sure?'),
                actions: [
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isRecording = false;
                      });
                    },
                  ),
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildRecordingIcon() {
    return IconButton(
      icon: const Icon(Icons.mic),
      iconSize: 80,
      color: Colors.red,
      onPressed: () {
        setState(() {
          isRecording = true;
          isPaused = false;
        });
      },
    );
  }

  Widget _buildPauseIcon() {
    return IconButton(
      icon: Icon(Icons.pause),
      iconSize: 80,
      onPressed:
          () => {
            setState(() {
              isPaused = true;
            }),
          },
    );
  }

  Widget _buildStopIcon() {
    return IconButton(
      icon: Icon(Icons.stop),
      iconSize: 80,
      onPressed:
          () => {
            setState(() {
              isRecording = false;
              isPaused = false;
            }),
          },
    );
  }

  Widget _buildIcons() {
    if (!isRecording) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildRecordingIcon()],
      );
    } else {
      if (!isPaused) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildBackIcon(), _buildPauseIcon(), _buildStopIcon()],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildBackIcon(), _buildRecordingIcon(), _buildStopIcon()],
        );
      }
    }
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Container(
        color: Colors.white,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListAudio(),

            Text('00:00:00', style: TextStyle(fontSize: 50)),

            _buildIcons(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white10, body: _buildUI());
  }
}
