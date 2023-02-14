import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../views/notepage.dart';

class NoteDisplay extends StatefulWidget {
  const NoteDisplay({super.key});

  @override
  State<NoteDisplay> createState() => _NoteDisplayState();
}

class _NoteDisplayState extends State<NoteDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap : () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) {
              return NotePage(content: "Hello world", onChildChanged: (String text) {  },);
            })
          );
        }
      )
    );
  }
}