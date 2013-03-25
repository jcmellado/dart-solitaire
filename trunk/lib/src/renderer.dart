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

class Renderer {
  final List<Sprite> _sprites = new List<Sprite>();

  Sprite active;

  void add(List<Sprite> sprites) {
    _sprites.addAll(sprites);
  }

  void draw() {
    _canvas.context2d.drawImageScaled(_settings.backgroundImage.image,
        0, 0, _canvas.width, _canvas.height);

    _sprites.sort();

    for (var sprite in _sprites) {
      sprite.draw();
    }
  }

  Sprite hovered(num x, num y) {
    var candidates = _sprites.where((sprite) => sprite.contains(x, y)).toList();

    candidates.sort();

    return candidates.isEmpty ? null : candidates.last;
  }

  void hover(Sprite sprite) {
    if (!identical(sprite, active)) {

      if (active != null) {
        active.activate(false);
      }

      active = sprite;

      if (active != null) {
        active.activate(true);
      }
    }
  }
}
