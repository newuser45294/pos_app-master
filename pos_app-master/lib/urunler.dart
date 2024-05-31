import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'interface.dart';
import 'neUrunler.dart';

class Urunler extends StatefulWidget {
  var uid;
  String keyd;
  Urunler(this.uid,this.keyd);

  @override
  State<Urunler> createState() => _UrunlerState();
}

class _UrunlerState extends State<Urunler> {
  var urunName = TextEditingController();
  var urunFiyat = TextEditingController();
  Future<void> urunAdd(String name, int fiyat) async {
    var ref =
        FirebaseDatabase.instance.ref().child("Users/${widget.keyd}/Urunler");
    var map = HashMap();
    map["name"] = name;
    map["fiyat"] = fiyat;
    ref.push().set(map);
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => NeUrunler(widget.uid,widget.keyd))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            title: Text("Urunler",
                style: TextStyle(color: Colors.white, fontSize: 36)),
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          NeUrunler(widget.uid, widget.keyd))));
            }),
          ),
          ListTile(
            title: Text("Masalar"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: ((context) => Interface(widget.uid,widget.keyd))));
            },
          )
        ],
      )),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: urunName,
                  decoration: InputDecoration(
                    hintText: "Urun Adı",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: urunFiyat,
                  decoration: InputDecoration(
                    hintText: "Fiyat",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  urunAdd(urunName.text, int.parse(urunFiyat.text));
                },
                child: Text("Ekle"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blueAccent,
                    minimumSize: Size(70, 50),
                    elevation: 0)),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
