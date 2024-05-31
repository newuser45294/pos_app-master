import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos_app/urun.dart';
import 'package:pos_app/urunler.dart';

import 'interface.dart';

class NeUrunler extends StatefulWidget {
  var uid;
  var keys;
  NeUrunler(this.uid,this.keys);

  @override
  State<NeUrunler> createState() => _NeUrunlerState();
}

class _NeUrunlerState extends State<NeUrunler> {
  Future<void> delete(var key) async {
    var ref =
        FirebaseDatabase.instance.ref().child("Users/${widget.keys}/Urunler");
    ref.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    var ref =
        FirebaseDatabase.instance.ref().child("Users/${widget.keys}/Urunler");
    return Scaffold(
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
              title: Text("Urunler"),
              onTap: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => NeUrunler(widget.uid,widget.keys))));
              }),
            ),
            ListTile(
              title: Text("Masalar"),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Interface(widget.uid,widget.keys))));
              },
            )
          ],
        )),
        backgroundColor: Colors.blue,
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Ürünler",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Urunler(widget.uid,widget.keys)));
                      },
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                          minimumSize: Size(70, 50),
                          elevation: 0)),
                ],
              )
            ],
          ),
          StreamBuilder<DatabaseEvent>(
              stream: ref.onValue,
              builder: (context, event) {
                var list = [];
                var keyList = [];
                if (event.hasData && event.data?.snapshot.value != null) {
                  var datan = event.data!.snapshot.value as dynamic;
                  datan.forEach((key, value) {
                    var dat = Urun.fromJson(value);
                    list.add(dat);
                    keyList.add(key);
                  });
                }
                if (event.data!.snapshot.value != null) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: Container(
                              margin: EdgeInsets.all(20),
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
                                  Text("${list[index].fiyat}",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        delete(keyList[index]);
                                      },
                                      child: Text("Sil"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent,
                                          onPrimary: Colors.white,
                                          minimumSize: Size(70, 50),
                                          elevation: 0))
                                ],
                              )),
                        );
                      }));
                } else {
                  return Center(
                    child: Text("Yok"),
                  );
                }
              })
        ]));
  }
}
