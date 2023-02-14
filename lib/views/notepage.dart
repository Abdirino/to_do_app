import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

typedef void CallBack(String text);

class NotePage extends StatefulWidget {
  var content;

  final CallBack onChildChanged;

  NotePage({super.key, required this.content, required this.onChildChanged});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    _controller.text = widget.content.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_controller.text.trim().isEmpty) {
          Navigator.pop(context, true);
        }
        _controller.text.trim();

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[600],
          centerTitle: true,
          title: Text('Notes'),
        ),
        body: SafeArea(
            child: Container(
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15),
                hintText: "Note here...",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none),
            controller: _controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            onChanged: ((value) {
              widget.onChildChanged(value.trim());
            }),
          ),
        )),
      ),
    );
  }
}
