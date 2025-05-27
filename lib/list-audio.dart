import 'package:flutter/material.dart';

class ListAudio extends StatefulWidget{
  @override
  _ListAudioState createState() => _ListAudioState();
  
}

class _ListAudioState extends State<ListAudio>{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Container(
        color: Colors.blue,
        child: ListView(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          children: <Widget>[
            Container(
              height: 35,
              color: Colors.amber[100],
              child: Text('Teste'),
            ),
            
          ],
        ),
      ),
    );
  }

}