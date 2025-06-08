import 'package:flutter/material.dart';
import 'package:record_audio/menu_widget.dart';
import 'package:record_audio/model/audio_item_model.dart';

class AudioItem extends StatefulWidget {
  const AudioItem({required this.audioItemModel, super.key});

  final AudioItemModel audioItemModel;

  @override
  _AudioItemState createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
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
          IconButton(
            icon: Icon(Icons.play_arrow, size: 45),
            onPressed: () => {},
          ),
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
