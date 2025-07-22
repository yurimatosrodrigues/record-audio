import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:record/record.dart';
import 'package:record_audio/list_audio.dart';
import 'package:record_audio/model/audio_item_model.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _readAudioFiles();
  }

  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  String filePath = '', currentAudioPlaying = '';

  bool isRecording = false, isPaused = false, isPlaying = false;

  Duration duration = Duration();
  Timer? timer;

  List<AudioItemModel> audioList = [];

  StreamSubscription<PlayerState>? listener;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

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
                      audioRecorder.cancel();
                      setState(() {
                        isRecording = false;
                        isPaused = false;
                        _stopTimer();
                        filePath = "";
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
      onPressed: () async {
        if (await audioRecorder.hasPermission()) {
          if (isPaused) {
            await audioRecorder.resume();
          } else {
            filePath = await _audioName();
            await audioRecorder.start(const RecordConfig(), path: filePath);
          }

          setState(() {
            isRecording = true;
            isPaused = false;
            _startTimer();
          });
        }
      },
    );
  }

  Widget _buildPauseIcon() {
    return IconButton(
      icon: Icon(Icons.pause),
      iconSize: 80,
      onPressed: () {
        setState(() {
          isPaused = true;
          audioRecorder.pause();
          _stopTimer(reset: false);
        });
      },
    );
  }

  Widget _buildStopIcon() {
    return IconButton(
      icon: Icon(Icons.stop),
      iconSize: 80,
      onPressed: () async {
        if (isRecording || isPaused) {
          String? recordedFilePath = await audioRecorder.stop();

          if (recordedFilePath != null) {
            setState(() {
              audioList.add(
                AudioItemModel(
                  title: recordedFilePath
                      .split('/')
                      .last
                      .replaceAll('.wav', ''),
                  path: recordedFilePath,
                  createAt: DateTime.now(),
                  isPlaying: false,
                ),
              );
              isRecording = false;
              isPaused = false;
              _stopTimer();
              filePath = "";
            });
          }
        }
      },
    );
  }

  Widget _buildActionButtons() {
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

  void _addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;

      duration = Duration(seconds: seconds);
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => _addTime());
  }

  void _stopTimer({bool reset = true}) {
    if (reset) {
      setState(() {
        duration = Duration();
      });
    }

    setState(() {
      timer?.cancel();
    });
  }

  void _readAudioFiles() async {
    audioList = [];
    List files = Directory(await _localPath).listSync();
    for (var element in files) {
      if (element is File) {
        if (element.path.endsWith('.wav')) {
          audioList.add(
            AudioItemModel(
              title: element.path.split('/').last.replaceAll('.wav', ''),
              path: element.path,
              createAt: element.lastModifiedSync(),
              isPlaying: false,
            ),
          );
          audioList.sort((a, b) => a.createAt.compareTo(b.createAt));
        }
      }
    }
  }

  void _playAudio(AudioItemModel audio) async {
    if (audio.isPlaying && currentAudioPlaying == audio.path) {
      await audioPlayer.pause();
      setState(() {
        audio.isPlaying = false;
      });
      return;
    }

    //quando reproduz o mesmo áudio
    if (currentAudioPlaying == audio.path &&
        audioPlayer.playerState.processingState == ProcessingState.completed) {
      await audioPlayer.seek(Duration.zero);
    }

    if (currentAudioPlaying != audio.path) {
      //caso esteja reproduzindo algum outro audio
      final currentlyPlaying = audioList.firstWhere(
        (a) => a.isPlaying,
        orElse:
            () => AudioItemModel(
              title: '',
              path: '',
              createAt: DateTime.now(),
              isPlaying: false,
            ),
      );

      setState(() {
        currentlyPlaying.isPlaying = false;
      });

      await audioPlayer.stop();
      await audioPlayer.setFilePath(audio.path);
      currentAudioPlaying = audio.path;
    }
    await audioPlayer.play();

    await listener?.cancel();

    listener = audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          audio.isPlaying = false;
        });
      }
    });
  }

  void onCompleteAction() {
    setState(() {
      _readAudioFiles();
    });
  }

  Future<String> _audioName() async {
    DateFormat format = DateFormat("yyyy-MM-dd-HHmmss");
    String formatted = format.format(DateTime.now());
    return p.join(await _localPath, 'Audio $formatted.wav');
  }

  Widget _buildCountUpTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text('$minutes:$seconds', style: TextStyle(fontSize: 50));
  }

  Widget _buildUI() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListAudio(
                audioList: audioList,
                onPlay: _playAudio,
                onCompleteAction: onCompleteAction,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Color.fromARGB(200, 135, 171, 202),
                  child: Column(
                    children: [_buildCountUpTime(), _buildActionButtons()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white10, body: _buildUI());
  }
}
