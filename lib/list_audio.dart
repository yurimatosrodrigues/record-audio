import 'package:flutter/material.dart';
import 'package:record_audio/menu_widget.dart';

class ListAudio extends StatefulWidget {
  @override
  _ListAudioState createState() => _ListAudioState();
}

class _ListAudioState extends State<ListAudio> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
          children: <Widget>[
            Container(
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
                    child: Text('Audio 1', style: TextStyle(fontSize: 25)),
                  ),
                  Menu(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
