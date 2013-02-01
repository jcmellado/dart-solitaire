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

abstract class TokenSprite extends Sprite {

  TokenSprite() {
    ow = 78;
    oh = 104;

    rw = 0.10;
    rh = 0.175;
  }
}

abstract class Sprite implements Comparable {
  num ox = 0;
  num oy = 0;
  num ow = 1;
  num oh = 1;

  num rx = 0;
  num ry = 0;
  num rw = 1;
  num rh = 1;

  num z = 0;

  num alpha = 1.0;

  String cursor = "auto";

  Image get spriteSheet;

  num get x => (rx * _canvas.width).toInt();
  num get y => (ry * _canvas.height).toInt();
  num get width => (rw * _canvas.width).toInt();
  num get height => (rh * _canvas.height).toInt();

  void draw() {
    _canvas.context2d.globalAlpha = alpha;
    _canvas.context2d.drawImage(spriteSheet.image, ox, oy, ow, oh, x, y, width, height);
  }

  void moveTo(num left, num top) {
    rx = left;
    ry = top;
  }

  void offsetTo(Sprite target, num left, num top) {
    moveTo(target.rx + left, target.ry + top);
  }

  int compareTo(Sprite other) => z.compareTo(other.z);

  bool contains(num left, num top) {
    return (left >= x)
        && (left < x + width)
        && (top >= y)
        && (top < y + height);
  }

  void activate(bool active) {
  }
}
