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

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Container(
        color: Colors.white,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '00:00:00',              
              style: TextStyle(
                fontSize: 50
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,              
              children: [
                Icon(
                  Icons.mic,
                  size: 80, 
                  color: Colors.red,
                ),
                Icon(              
                  Icons.pause,
                  size: 100,               
                ),
                Icon(
                  Icons.stop,
                  size: 110,
                )
              ],
            )                 
          ],
        ) 
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