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

class Card extends TokenSprite {
  final num suit;
  final num number;
  final num color;

  Pile pile;

  bool _faceUp;

  Card(this.suit, this.number, this.color) {
    cursor = "pointer";

    faceDown();
  }

  bool get isFaceUp => _faceUp;

  Image get spriteSheet => isFaceUp ? _settings.frontImage : _settings.backImage;

  void faceUp() {
    _faceUp = true;

    ox = (number - 1) * ow;
    oy = suit * oh;
  }

  void faceDown() {
    _faceUp = false;

    ox = 0;
    oy = 0;
  }
}

class Drag {
  final Card card;

  final num _rx;
  final num _ry;
  final num _z;

  final num _offsetX;
  final num _offsetY;

  Drag(Card card, int x, int y)
    : this.card = card,
      _rx = card.rx,
      _ry = card.ry,
      _z = card.z,
      _offsetX = x - card.x,
      _offsetY = y - card.y {

    card.z += 100;
  }

  void moveTo(int x, int y) {
    card.moveTo((x - _offsetX) / _canvas.width, (y - _offsetY) / _canvas.height);
  }

  void cancel() {
    card.rx = _rx;
    card.ry = _ry;
    card.z = _z;
  }
}
