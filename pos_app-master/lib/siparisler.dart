import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos_app/interface.dart';
import 'package:pos_app/siparis.dart';
import 'package:pos_app/urun.dart';
import 'package:pos_app/urunler.dart';

class Siparisler extends StatefulWidget {
  String keys;
  String keyd;
  Siparisler(this.keyd, this.keys);

  @override
  State<Siparisler> createState() => _SiparislerState();
}

class _SiparislerState extends State<Siparisler> {
  @override
  Widget build(BuildContext context) {
    var ref =
        FirebaseDatabase.instance.ref().child("Users/${widget.keyd}/Urunler");
    var ref2 = FirebaseDatabase.instance
        .ref()
        .child("Users/${widget.keyd}/Masalar/${widget.keys}/Siparisler");
    Future<void> siparisAdd(String name, int fiyat) async {
      var map = HashMap();
      map["name"] = name;
      map["fiyat"] = fiyat;
      ref2.push().set(map);
    }

    var itemList = <String>["name", "hello"];
    var data = "name";
    return Scaffold(
        appBar: AppBar(
          title: Text("Siparisler"),
        ),
        backgroundColor: Colors.white,
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<DatabaseEvent>(
                  stream: ref.onValue,
                  builder: (context, event) {
                    var list = <Urun>[];
                    if (event.hasData && event.data!.snapshot.value != null) {
                      var de = event.data!.snapshot.value as dynamic;
                      de.forEach((key, value) {
                        var d = Urun.fromJson(value);
                        list.add(d);
                        
                      });
                    }
                    var urun = list[0];
                    var urunName;
                    var urunFiyat;
                    return Row(
                      children: [
                        DropdownButton<Urun>(
                            value: urun,
                            items:
                                list.map<DropdownMenuItem<Urun>>((Urun? value) {
                              return DropdownMenuItem<Urun>(
                                value: value,
                                child: Text("${value!.name} | ${value.fiyat}"),
                              );
                            }).toList(),
                            onChanged: ((Urun? Newvalue) {
                              setState(() {
                                urun = Newvalue!;
                                urunName = urun.name;
                                urunFiyat = urun.fiyat;
                                siparisAdd(urunName, urunFiyat);
                              });
                            })),
                      ],
                    );
                  }),
            ],
          ),
          StreamBuilder<DatabaseEvent>(
              stream: ref2.onValue,
              builder: (context, event) {
                var list = [];
                if (event.hasData && event.data!.snapshot.value != null) {
                  var rf = event.data!.snapshot.value as dynamic;
                  rf.forEach((key, data) {
                    var mn = Siparis.fromJson(data);
                    list.add(mn);
                  });
                }
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
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                      );
                    }));
              })
        ]));
  }
}
