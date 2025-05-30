import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Menu extends StatefulWidget {
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
                      builder: (BuildContext) {
                        return SimpleDialog(title: Text('tst'));
                      },
                    ),
                  },
            ),
          ],
    );
  }
}
