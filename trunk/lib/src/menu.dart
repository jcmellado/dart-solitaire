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

class Overlay {
  final String _basename;
  final html.Element _overlay;

  Overlay(String basename)
    : _basename = basename,
      _overlay = html.querySelector("#overlay-${basename}");

  void open() {
    _setVisible(true);
  }

  void close() {
    _setVisible(false);
  }

  void _setVisible(bool visible) {
    _overlay.style.visibility = visible ? "visible" : "hidden";
  }
}

class ModalWindow extends Overlay {
  async.StreamSubscription _subscription;

  ModalWindow(String basename) : super(basename) {
    _subscription = _overlay.querySelector(".close").onClick.listen(_onClose);
  }

  void addButton(String text, void callback()) {
    var button = new html.ButtonElement()
      ..classes.add("button")
      ..text = text
      ..onClick.listen((_) => callback());

    _overlay.querySelector(".modal-footer").append(button);
  }

  void close() {
    _subscription.cancel();

    _overlay.querySelector(".modal-footer").children.clear();

    super.close();
  }

  void _onClose(html.Event event) {
    close();
  }
}

class MessageBox extends ModalWindow{

  MessageBox(String message) : super("msgbox") {
    _overlay.querySelector("#message-${_basename}").text = message;
  }
}

class SettingsDialog extends ModalWindow {
  html.SelectElement _draw;
  html.SelectElement _background;
  html.SelectElement _front;

  SettingsDialog() : super("settings") {
    _draw = _overlay.querySelector("#draw-${_basename}");
    _background = _overlay.querySelector("#background-${_basename}");
    _front = _overlay.querySelector("#front-${_basename}");
  }

  void addDrawOptions(int current) {
    _addOptions(_draw, _DRAW_OPTIONS, current.toString());
  }

  void addBackgroundOptions(Image current) {
    _addOptions(_background, _BACKGROUND_OPTIONS, current.toString());
  }

  void addFrontOptions(Image current) {
    _addOptions(_front, _FRONT_OPTIONS, current.toString());
  }

  int getDraw() => _DRAW_OPTIONS[_draw.selectedIndex];
  Image getBackground() => _BACKGROUND_OPTIONS[_background.selectedIndex];
  Image getFront() => _FRONT_OPTIONS[_front.selectedIndex];

  void close() {
    _draw.children.clear();
    _background.children.clear();
    _front.children.clear();

    super.close();
  }

  void _addOptions(html.SelectElement select, List options, String current) {
    for (var option in options) {
      var value = option.toString();

      var element = new html.OptionElement(data: value, value: value, selected: value == current);

      select.append(element);
    }
  }
}

class GameOver extends Overlay {
  Function onUpdate;
  Function onClick;

  async.StreamSubscription _subscription;

  GameOver() : super("gameover") {
    _subscription = _overlay.onClick.listen(_onClick);
  }

  void _onClick(html.Event event) {
    if (onClick != null) {
      onClick();
    }
  }

  void close() {
    _subscription.cancel();

    super.close();
  }
}
