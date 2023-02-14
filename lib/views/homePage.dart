import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/views/notepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box box;

  Set<int> selected_Index = new Set();
  bool is_selected = false;
  List content = [];

  @override
  void initState() {
    super.initState();
    box = Hive.box("Notes");

    box.isEmpty ? print("none") : _getNotes();
  }

  void _getNotes() {
    setState(() {
      content.addAll(box.get("Notes"));
    });
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
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
                      })
                ]
              : [],
          backgroundColor: Color.fromARGB(255, 137, 246, 49),
          centerTitle: true,
          title: Text(
            "To-Do App",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        //
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lime,
          child: Icon(Icons.add),
          onPressed: () {
            int index = content.length;
            setState(() {
              content.add("");
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotePage(
                        content: content[index],
                        onChildChanged: (String data) {
                          setState(() {
                            content[index] = data;
                          });
                        }))).then((value) => {
                  if (value == true)
                    {
                      setState(() {
                        content.removeLast();
                      })
                    }
                });
          },
        ),
        body: SafeArea(
            child: content.isEmpty
                ? Center(
                    child: Text(
                      "No content \n Add notes to display",
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
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotePage(
                                            content: content[index],
                                            onChildChanged: (String data) {
                                              setState(() {
                                                content[index] = data;
                                              });
                                            }))).then((value) => {
                                      if (value == true)
                                        {
                                          print("Works"),
                                          setState(() {
                                            content.removeAt(index);
                                          }),
                                          box.put("Notes", content),
                                          print(box.values)
                                        }
                                    });
                          },
                          child: Text("${content[index]}")),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected_Index.contains(index)
                              ? Colors.green
                              : Colors.black,
                          width: selected_Index.contains(index) ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.fit(1);
                    },
                  )));
  }
}
