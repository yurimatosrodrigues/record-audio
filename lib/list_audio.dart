import 'package:flutter/material.dart';
import 'package:record_audio/audio_item_widget.dart';
import 'package:record_audio/model/audio_item_model.dart';

class ListAudio extends StatefulWidget {
  const ListAudio({super.key, required this.audioList});

  final List<AudioItemModel> audioList;

  @override
  _ListAudioState createState() => _ListAudioState();
}

class _ListAudioState extends State<ListAudio> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: widget.audioList.length,

        itemBuilder: (context, index) {
          return AudioItem(audioItemModel: widget.audioList[index]);
        },
      ),
    );
  }
}
