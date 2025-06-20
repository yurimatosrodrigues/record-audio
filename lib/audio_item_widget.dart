import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record_audio/menu_widget.dart';
import 'package:record_audio/model/audio_item_model.dart';

class AudioItem extends StatefulWidget {
  const AudioItem({
    super.key,
    required this.audioItemModel,
    required this.onPlay,
  });

  final AudioItemModel audioItemModel;
  final void Function(AudioItemModel) onPlay;

  @override
  _AudioItemState createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  bool isPlaying = false;

  Widget _buildPlayIcon() {
    return IconButton(
      icon: Icon(Icons.play_arrow, size: 45),
      onPressed: () {
        widget.onPlay(widget.audioItemModel);
        setState(() {
          isPlaying = true;
        });
      },
    );
  }

  Widget _buildPauseIcon() {
    return IconButton(
      icon: Icon(Icons.pause, size: 45),
      onPressed: () {
        widget.onPlay(widget.audioItemModel);
        setState(() {
          isPlaying = false;
        });
      },
    );
  }

  Widget _builActionButtons() {
    if (isPlaying) {
      return _buildPauseIcon();
    } else {
      return _buildPlayIcon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 14, 135, 230),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _builActionButtons(),
          Expanded(
            child: Text(
              widget.audioItemModel.title,
              style: TextStyle(fontSize: 25),
            ),
          ),
          Menu(),
        ],
      ),
    );
  }
}
