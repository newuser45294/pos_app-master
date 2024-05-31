import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/firebase_options.dart';
import 'package:pos_app/interface.dart';
import 'package:pos_app/users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> register(String email, String password) async {
    print("calışıypr");
    try {
      var auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((val) async {
        var ref = FirebaseDatabase.instance.ref().child("Users");
        var map = HashMap();
        map["uid"] = val.user!.uid;
        await ref.push().set(map);
      
        ref.onValue.listen((event) {
          var dataz = event.snapshot.value as dynamic;
          dataz.forEach((key, data) {
            var val1 = Users.fromJson(data);
            if (val1.uid == val.user?.uid) {
            
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Interface(val.user!.uid, "${key}")));

            }
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    }

   Future<void> logIn(String email, String password) async {
    try {
      var auth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        var ref = FirebaseDatabase.instance.ref().child("Users");
      
        ref.onValue.listen((event) {
          var data = event.snapshot.value as dynamic;
          data.forEach((key, data) {
            var val1 = Users.fromJson(data);
            if (val1.uid == value.user!.uid) {
              if (true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Interface(value.user!.uid, "${key}")));
              }
            }
          });
        });
      });
    } on FirebaseAuthException catch (e) {}}

  var email = TextEditingController();
  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                  controller: password,
                  decoration: InputDecoration(
                    hintText: "Password",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    child: Text("Sıgn In"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blueAccent,
                        minimumSize: Size(70, 50),
                        elevation: 0)),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () => register(email.text,password.text),
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blueAccent,
                        minimumSize: Size(70, 50),
                        elevation: 0))
              ],
            )
          ],
        ),
      ),
    );
  }
}

