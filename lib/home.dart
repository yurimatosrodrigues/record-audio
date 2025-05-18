import 'package:flutter/material.dart'; 
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:record/record.dart';

class Home extends StatefulWidget{
  const Home({super.key});
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false, isPlaying = false;

  Widget _recordingButton(){
    return FloatingActionButton(
      onPressed: () async {
        if(isRecording){
          String? filePath = await audioRecorder.stop();

          if(filePath != null){
            setState((){
              isRecording = false;
              recordingPath = filePath;
            });
          }
        }
        else{
          if(await audioRecorder.hasPermission()){
            final Directory appDocumentsDir = await getApplicationCacheDirectory();

            final String filePath = p.join(appDocumentsDir.path, 'recording.wav');

            await audioRecorder.start(
              const RecordConfig(), 
              path: filePath,
            );

            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }

  Widget _buildUI(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Container(
        color: Colors.white,
        child: Column(        
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(recordingPath != null) 
              MaterialButton(
                onPressed: () async {
                  if(audioPlayer.playing){
                    audioPlayer.stop();

                    setState(() {
                      isPlaying = false;
                    });
                  }
                  else{
                    await audioPlayer.setFilePath(recordingPath!);
                    audioPlayer.play();
                    setState(() {
                      isPlaying = true;
                    });
                  }

                },
                color: Theme.of(context).colorScheme.primary,
                child: Text(isPlaying ? "Stop Playing Recording" : "Start Playing Recording"),
              ),

            if(recordingPath == null)
              const Text("No Recording Found."),
        ]
      ),
      )      
    );
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white10,
      floatingActionButton: _recordingButton(),
      body: _buildUI(),
    );
  }

}