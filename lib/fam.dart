import 'dart:math';
import 'dart:ui';

class Fam {
  final String name;
  DateTime lastSuh;
  Color colorTheyLastSentMe = DummyColor.dummyTheySentMe;

  Fam({this.name, this.lastSuh, this.colorTheyLastSentMe});
}

class DummyColor {
  static Color get dummyTheySentMe => _getColor();

  static Color _getColor() {
    var random = Random().nextInt(255);
    var random2 = Random().nextInt(255);
    var random3 = Random().nextInt(255);
    return Color.fromRGBO(random, random2, random3, 1.0);
  }
}
