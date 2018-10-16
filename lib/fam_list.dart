import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:suh/fam.dart';

/// [SuhFamList] is a stateful Widget that updates when:
///      1. a user receives a new message from a fam, or
///      2. a user adds a new fam to their fam list.
class SuhFamList extends StatefulWidget {
  final String title;
  final Stream<Fam> famStream;

  SuhFamList(this.famStream, {Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SuhFamListState();
  }
}

class _SuhFamListState extends State<SuhFamList> {
  // CHECK IT OUT!!
  //        Map<String, Fam> nameToFam = Map();
  //
  // nameToFam is a MAP, which is our way of keeping track of who from our fam
  // list has sent us a message.
  //
  // An example of an item in our map looks like this:
  //
  //        'kelsey': {
  //           lastSuh: 11/27/2018 4:30PM         // a DateTime object
  //           lastChar: 'e'                      // our app allows for one character messages
  //           lastColor: RGB(25, 222, 50, 1.0)   // RGB is how we represent colors with red, green, blue values from 0-255
  //         }
  //
  //
  //    EXERCISE!!! Can you write your own nameToFam map object below, to the person
  //                beside you? Feel free to send an emoji as your message
  //
  //       '': {
  //           lastSuh:                   // a DateTime object
  //           lastChar: ''               // our app allows for one character messages
  //           lastColor:                 // RGB is how we represent colors with red, green, blue values from 0-255
  //         }
  //
  //
  //    Now imagine we have a bunch of items in our map from all our friends.
  //
  //    This is how we populate our home screen list of last sent messages and colors!
  //
  //
  Map<String, Fam> nameToFam = Map();
  TextEditingController _controller = TextEditingController();
  StreamSubscription _dummyStream;

  // dispose() is our function where we define what we want to happen after we're
  // done with our list. You can think of it like taking out the trash in our app
  // so we don't leave anything behind that causes it to be slow.
  @override
  void dispose() {
    _dummyStream.cancel();

    super.dispose();
  }

  // initState() is our function where we define how we want the app to start
  // off looking -- also called our "initial state."
  @override
  initState() {
    super.initState();

    _dummyStream = widget.famStream.listen((Fam fam) {
      setState(() {
        var thisFam = nameToFam[fam.name];

        if (thisFam != null) {
          thisFam
            ..colorTheyLastSentMe = fam.colorTheyLastSentMe
            ..lastSuh = fam.lastSuh;
        }
      });
    });
  }

  // _addFam() is our function that we call when we click the + button!
  //
  // It shows the dialog where we type our fam's name to add them to our list.
  void _addFam(BuildContext context) async {
    String newFam = await showDialog(context: context, builder: _buildFam);
    setState(() {
      nameToFam[newFam] = Fam(name: newFam, lastSuh: null);
    });
  }

  // TODO refactor to use proper nested form so that enter press will set state
  Widget _buildFam(BuildContext context) {
    return SimpleDialog(
      title: Text('Add Fam'),
      children: <Widget>[
        Form(child: FormField(builder: _buildFamFormField)),
        FlatButton(
          child: Text('Add Fam'),
          onPressed: () {
            Navigator.pop<String>(context, _controller.value.text);
          },
        )
      ],
    );
  }

  Widget _buildFamFormField(_) {
    return TextField(
      autofocus: true,
      controller: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _famWidgets(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFam(context);
        },
        tooltip: 'Add Fam',
        child: new Icon(Icons.add),
      ),
    );
  }

  List<Widget> _famWidgets() {
    List<Widget> tiles = [];
    for (var fam in nameToFam.values) {
      tiles.add(Container(
          decoration: new BoxDecoration(
            color: fam.colorTheyLastSentMe,
          ),
          child: ListTile(
            title: Text(fam.name),
            subtitle: Text(_readableLastSuh(fam.lastSuh)),
            onTap: _pickColorToSend,
            onLongPress: () {
              _removeFam(fam);
            },
          )));
    }
    return tiles;
  }

  // This _readableLastSuh() function makes a DateTime that is a bunch of crazy
  // numbers  to be a human-readable time and date, i.e. 15:35:21 - October 14, 2018
  String _readableLastSuh(DateTime dt) {
    if (dt == null) {
      return '';
    }
    // TODO map ${dt.month} to const
    return '${dt.hour}:${dt.minute}:${dt.second} - October ${dt.day}, ${dt.year}';
  }

  // _removeFam() deletes someone from the user's fam list
  _removeFam(Fam fam) {
    setState(() {
      nameToFam.remove(fam.name);
    });
  }

  _pickColorToSend() {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: const Text('Pick a color!'),
        content: new SingleChildScrollView(child: _colorPicker()),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Got it'),
            onPressed: () {
              // setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _colorPicker() {
    return ColorPicker(
      pickerColor: Color.fromRGBO(255, 52, 22, 1.0),
      onColorChanged: (Color newColor) {
        // setState(() => fam.colorILastSent = newColor);

        // will be firebase call
      },
      enableLabel: true,
      pickerAreaHeightPercent: 0.8,
    );
  }
}
