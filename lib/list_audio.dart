import 'package:flutter/material.dart';
import 'package:record_audio/menu_widget.dart';
import 'package:record_audio/model/audio_item_model.dart';

class ListAudio extends StatefulWidget {
  List<AudioItemModel> audioList = [
    AudioItemModel(title: 'Audio 1', path: '', createAt: DateTime.now()),
    AudioItemModel(title: 'Audio 2', path: '', createAt: DateTime.now()),
  ];

  @override
  _ListAudioState createState() => _ListAudioState();
}

class _ListAudioState extends State<ListAudio> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Container(
        child: ListView.builder(
          itemCount: widget.audioList.length,

          itemBuilder: (context, index) {
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
                      widget.audioList[index].title,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Menu(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
