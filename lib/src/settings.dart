/*
  Copyright (c) 2013 Juan Mellado

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/

part of solitaire;

const List<int> _DRAW_OPTIONS = const [1, 3];

final List<Image> _BACKGROUND_OPTIONS =
  [new Image("Classic", "images/backgrounds/classic.png"),
   new Image("Marine", "images/backgrounds/marine.png"),
   new Image("Scarlet", "images/backgrounds/scarlet.png")];

final List<Image> _FRONT_OPTIONS =
  [new Image("Dart", "images/fronts/dart.png"),
   new Image("Big", "images/fronts/big.png")];

const String _BACK_IMAGE = "images/backs/dart.png";

const String _PILE_IMAGE = "images/piles/basic.png";

final Map _DEFAULT_SETTINGS = {
  "cardsToDraw": _DRAW_OPTIONS[1],
  "backgroundImage": {
    "name": _BACKGROUND_OPTIONS[0].name,
    "src": _BACKGROUND_OPTIONS[0].src
  },
  "frontImage": {
    "name": _FRONT_OPTIONS[0].name,
    "src": _FRONT_OPTIONS[0].src
  }
};

class Settings {
  static const String _KEY = "dart.solitaire.settings";

  num cardsToDraw;
  Image backgroundImage;
  Image frontImage;

  final Image backImage = new Image.fromSrc(_BACK_IMAGE);
  final Image pileImage = new Image.fromSrc(_PILE_IMAGE);

  factory Settings() {
    return new Settings.fromJson(_restore());
  }

  Settings.fromJson(Map map) {
    cardsToDraw = map["cardsToDraw"];
    backgroundImage = new Image.fromJson(map["backgroundImage"]);
    frontImage = new Image.fromJson(map["frontImage"]);
  }

  Map toJson() {
    return new Map()
      ..["cardsToDraw"] = cardsToDraw
      ..["backgroundImage"] = backgroundImage
      ..["frontImage"] = frontImage;
  }

  void save() {
    html.window.localStorage[_KEY] = convert.JSON.encode(this);
  }

  static Map _restore() {
    var string = html.window.localStorage[_KEY];

    return string == null ? _DEFAULT_SETTINGS : convert.JSON.decode(string);
  }
}
