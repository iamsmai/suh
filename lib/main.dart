import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:suh/fam.dart';
import 'package:suh/fam_list.dart';

void main() {
  // TODO close stream
  StreamController<Fam> famStreamController = StreamController();

  Timer.periodic(Duration(seconds: 5), (_) {
    famStreamController.add(Fam(
        name: 'test',
        lastSuh: DateTime.now(),
        colorTheyLastSentMe: DummyColor.dummyTheySentMe));

    famStreamController.add(Fam(
        name: 'test2',
        lastSuh: DateTime.now(),
        colorTheyLastSentMe: DummyColor.dummyTheySentMe));

    famStreamController.add(Fam(
        name: 'test3',
        lastSuh: DateTime.now(),
        colorTheyLastSentMe: DummyColor.dummyTheySentMe));

    famStreamController.add(Fam(
        name: 'test4',
        lastSuh: DateTime.now(),
        colorTheyLastSentMe: DummyColor.dummyTheySentMe));
  });

  runApp(new SuhApp(famStreamController.stream));
}

class SuhApp extends StatelessWidget {
  Stream<Fam> famStream;

  SuhApp(this.famStream) : super();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Suh',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new SuhFamList(famStream, title: 'Suh'),
    );
  }
}

// TODO AUTHORIZATION FOR MVP?!?!
//
//
// Widget _handleCurrentScreen() {
//   return new StreamBuilder<FirebaseUser>(
//       stream: FirebaseAuth.instance.onAuthStateChanged,
//       builder: (BuildContext context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return new SplashScreen();
//         } else {
//           if (snapshot.hasData) {
//             return new SuhApp(firestore: firestore,
//                 uuid: snapshot.data.uid);
//           }
//           return new LoginScreen();
//         }
//       }
//     );
// }
