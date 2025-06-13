import 'package:flutter/material.dart';
import 'package:record_audio/audio_item_widget.dart';
import 'package:record_audio/model/audio_item_model.dart';

class ListAudio extends StatefulWidget {
  const ListAudio({super.key, required this.audioList, required this.onPlay});

  final List<AudioItemModel> audioList;
  final void Function(AudioItemModel) onPlay;

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
          return AudioItem(
            audioItemModel: widget.audioList[index],
            onPlay: widget.onPlay,
          );
        },
      ),
    );
  }
}
