import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/views/notepage.dart';

class deletedNotes extends StatefulWidget {
  const deletedNotes({super.key});

  @override
  State<deletedNotes> createState() => _deletedNotesState();
}

class _deletedNotesState extends State<deletedNotes> {
  late final Box deleted_box;
  late final Box Restored_box;

  Set<int> selected_Index = new Set();
  bool is_selected = false;
  List content = [];
  List Restored_content = [];

  @override
  void initState() {
    super.initState();
    deleted_box = Hive.box("deleted_notes");
    Restored_box = Hive.box("notes");

    deleted_box.isEmpty ? print("none") : _getNotes();
  }

  void _getNotes() {
    setState(() {
      content.addAll(deleted_box.get("deleted_notes"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: is_selected && selected_Index.isNotEmpty
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            selected_Index.clear();
                            is_selected = false;
                          });
                        },
                        icon: Icon(Icons.cancel)),
                    Center(
                        child: Container(
                      width: 8,
                      child: Text("${selected_Index.length}",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ))
                  ],
                )
              : null,
          actions: is_selected && selected_Index.isNotEmpty
              ? [
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        List toBeDel = [];
                        toBeDel.addAll(selected_Index);
                        toBeDel.sort();
                        toBeDel = toBeDel.reversed.toList();
                        for (var index in toBeDel) {
                          setState(() {
                            is_selected = false;

                            content.removeAt(index);
                          });
                        }
                        setState(() {
                          selected_Index.clear();
                        });
                        deleted_box.put("deleted_notes", content);
                      }),
                  IconButton(
                      icon: Icon(Icons.restore),
                      onPressed: () {
                        List toBeRestored = [];
                        toBeRestored.addAll(selected_Index);
                        toBeRestored.sort();
                        toBeRestored = toBeRestored.reversed.toList();
                        for (var index in toBeRestored) {
                          setState(() {
                            is_selected = false;
                            Restored_content.add(content[index]);
                            content.removeAt(index);
                          });
                        }
                        setState(() {
                          selected_Index.clear();
                        });
                        deleted_box.put("deleted_notes", content);
                        Restored_box.put("notes", Restored_content);
                      }),
                ]
              : [],
          backgroundColor: Color.fromARGB(255, 137, 246, 49),
          centerTitle: true,
          title: Text(
            "Deleted Notes",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
            child: content.isEmpty
                ? Center(
                    child: Text(
                      "No Deleted Notes \n Delete notes to display",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  )
                : StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 4,
                    itemCount: content.length,
                    itemBuilder: (context, index) => Container(
                      child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              is_selected = true;
                              selected_Index.contains(index)
                                  ? selected_Index.remove(index)
                                  : selected_Index.add(index);
                            });
                          },
                          onTap: () {
                            is_selected && selected_Index.isNotEmpty
                                ? setState(() {
                                    is_selected = true;
                                    selected_Index.contains(index)
                                        ? selected_Index.remove(index)
                                        : selected_Index.add(index);
                                  })
                                : null;
                          },
                          child: Container(
                            child: Hero(
                                tag: "Hero",
                                child: Material(
                                    child: Text(
                                  "${content[index]}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    wordSpacing: 1,
                                  ),
                                ))),
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: content[index].trim().isEmpty
                                    ? Colors.transparent
                                    : selected_Index.contains(index)
                                        ? Colors.green
                                        : Color.fromARGB(153, 0, 0, 0),
                                width: selected_Index.contains(index) ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                    ),
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.fit(1);
                    },
                  )));
  }
}
