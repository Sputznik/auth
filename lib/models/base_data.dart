import 'dart:math';
import 'dart:convert';

class BaseData{

  String getRandomID() {
    var rng = new Random();
    return base64.encode([rng.nextInt(10), rng.nextInt(10)]);
  }

  Map toJson() => {};

  String toString() => this.toJson().toString();

}