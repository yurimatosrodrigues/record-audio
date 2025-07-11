import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_audio/model/audio_item_model.dart';
import 'dart:io';

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required AudioItemModel this.audioItemModel,
    required VoidCallback this.onCompleteAction,
  });

  final AudioItemModel audioItemModel;
  final VoidCallback onCompleteAction;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder:
          (context) => [
            PopupMenuItem(
              child: Text('Rename'),
              onTap:
                  () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext) {
                        return SimpleDialog(title: Text('tst'));
                      },
                    ),
                  },
            ),

            PopupMenuItem(
              child: Text('Share'),
              onTap:
                  () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext) {
                        return SimpleDialog(title: Text('tst'));
                      },
                    ),
                  },
            ),

            PopupMenuItem(
              child: Text('Delete'),
              onTap:
                  () => {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Audio will be deleted.'),
                          content: Text('Are you sure?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                var file = File(widget.audioItemModel.path);
                                file.delete(recursive: false);
                                widget.onCompleteAction();
                                Navigator.of(context).pop();
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    ),
                  },
            ),
          ],
    );
  }
}
