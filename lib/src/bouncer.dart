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

// References:
// - Winning Solitaire
// http://mrdoob.com/lab/javascript/effects/solitaire/

part of solitaire;

class Bouncer {
  final math.Random random = new math.Random();

  final Iterator<Card> _cards;

  num sx;
  num sy;

  Bouncer(this._cards);

  void start() {
    _next();
  }

  void stop() {
    while(_cards.moveNext());
  }

  void update() {
    var card = _cards.current;
    if (card != null) {
      card.rx += sx;
      card.ry += sy;

      if (card.ry > (1 - card.rh)) {
        card.ry = 1 - card.rh;
        sy = -sy * 0.85;
      }
      sy += 0.00098;

      card.draw();

      if ((card.rx < -card.rw) || (card.rx > 1)) {
        _next();
      }
    }
  }

  void _next() {
    if (_cards.moveNext()) {
      sx = random.nextInt(13) - 6;
      sy = -random.nextInt(17);

      if (sx == 0) {
        sx = 2;
      }

      sx /= 1000;
      sy /= 1000;
    }
  }
}
