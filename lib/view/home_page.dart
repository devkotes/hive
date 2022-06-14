import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_localstorage/model/monster.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database Demo'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('monsters'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              var monstersBox = Hive.box('monsters');
              if (monstersBox.isEmpty) {
                monstersBox.add(Monster('vampir', 1));
                monstersBox.add(Monster('Jelly Guradian', 5));
              }
              return ValueListenableBuilder(
                valueListenable: monstersBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.values.isEmpty) {
                    return Text('data is empty');
                  } else {
                    return Container(
                      margin: EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          Monster monster = box.getAt(index);
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(3, 3),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  monster.name +
                                      " [ " +
                                      monster.level.toString() +
                                      " ]",
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        box.putAt(
                                          index,
                                          Monster(
                                              monster.name, monster.level + 1),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.trending_up,
                                        color: Colors.green,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        box.add(
                                          Monster(monster.name, monster.level),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.content_copy,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        box.deleteAt(index);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
