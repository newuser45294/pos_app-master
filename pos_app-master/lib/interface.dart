import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos_app/masalar.dart';
import 'package:pos_app/siparisler.dart';
import 'package:pos_app/urunler.dart';
import 'package:pos_app/users.dart';

import 'neUrunler.dart';

class Interface extends StatefulWidget {
  var uid;
  String keys;
  Interface(this.uid, this.keys);

  @override
  State<Interface> createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {
  Future<dynamic> push(String masaNameS) async {
    int index = 0;
    var keyn;
    var ref = FirebaseDatabase.instance.ref().child("Users");

    ref.onValue.listen((event) {
      var data = event.snapshot.value as dynamic;
      data.forEach((key, data) {
        var value = Users.fromJson(data);
        if (value.uid == widget.uid) {
          var ref2 =
              FirebaseDatabase.instance.ref().child("Users/${key}/Masalar");
          index++;
          if (1 >= index) {
            var map = HashMap();
            map["masa"] = masaNameS;
            ref2.push().set(map);
          }
        }
      });
    });
    return keyn;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var masaName = TextEditingController();
    int index = 0;
    var keyn;
    var ref =
        FirebaseDatabase.instance.ref().child("Users/${widget.keys}/Masalar");
    print(widget.keys);
    return Scaffold(
        backgroundColor: Colors.blue,
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
              title: Text("Urunler"),
              onTap: (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => NeUrunler(widget.uid,widget.keys))));
              }),
            ),
            ListTile(title: Text("Masalar"))
          ],
        )),
        body: StreamBuilder<DatabaseEvent>(
            stream: ref.onValue,
            builder: (context, event) {
              var list = [];
              if (event.hasData && event.data?.snapshot.value != null) {
                var data = event.data?.snapshot.value as dynamic;
                data.forEach((key, value) {
                  var masa = Masa.fromJson(key, value);
                  list.add(masa);
                });
              }
              if (event.data?.snapshot.value != null) {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Row(
                          children: [
                            Text("Masalar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold)),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          actions: [
                                            TextField(
                                              controller: masaName,
                                              decoration: InputDecoration(
                                                  hintText: "Masa Adı"),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  push(masaName.text);
                                                },
                                                child: Text("Add"),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.blueAccent,
                                                    onPrimary: Colors.white,
                                                    minimumSize: Size(70, 50),
                                                    elevation: 0))
                                          ],
                                        );
                                      }));
                                },
                                child: Icon(Icons.add),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                    onPrimary: Colors.white,
                                    minimumSize: Size(70, 50),
                                    elevation: 0)),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: ((context, index) {
                              return Card(
                                child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Text("${list[index].name}",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Siparisler(widget.keys,list[index].key)));
                                            },
                                            child: Text("Siparisler"),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blueAccent,
                                                onPrimary: Colors.white,
                                                minimumSize: Size(70, 50),
                                                elevation: 0))
                                      ],
                                    )),
                              );
                            }))
                      ]);
                    });
              } else {
                return Row(
                  children: [
                    Text("Masalar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold)),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  actions: [
                                    TextField(
                                      controller: masaName,
                                      decoration:
                                          InputDecoration(hintText: "Masa Adı"),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          push(masaName.text);
                                        },
                                        child: Text("Add"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blueAccent,
                                            onPrimary: Colors.white,
                                            minimumSize: Size(70, 50),
                                            elevation: 0))
                                  ],
                                );
                              }));
                        },
                        child: Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            onPrimary: Colors.white,
                            minimumSize: Size(70, 50),
                            elevation: 0)),
                  ],
                );
              }
            }));
  }
}
