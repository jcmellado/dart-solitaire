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

class Game {
  static const MIN_WIDTH = 320;
  static const MIN_HEIGHT = 240;

  final Deck _deck = new Deck();
  final Board _board = new Board();
  final Renderer _renderer = new Renderer();
  final html.Element _container = html.querySelector("#container");
  final Stopwatch _lastClick = new Stopwatch();

  Game() {
    _lastClick.start();
  }

  void start() {
    _newGame();

    _renderer.add(_board.piles);
    _renderer.add(_deck.cards);
    _addListeners();

    _container.style.visibility = "visible";
    _onResize(null); //IE
  }

  void _newGame() {
    _deck.shuffle(new math.Random().nextInt((1 << 16) - 1));
    _restart();
  }

  void _restart() {
    _board.clear();
    _board.deal(_deck.cards);
  }

  void _render() {
    _renderer.draw();
  }

  void _addListeners() {
    html.window.onLoad.listen(_onResize);
    html.window.onResize.listen(_onResize);

    _canvas.onClick.listen(_onClick);
    _canvas.onDoubleClick.listen(_onDoubleClick);
    _canvas.onDragStart.listen(_onDragStart);

    html.window.onMouseMove.listen(_onMouseMove);
    html.window.onMouseUp.listen(_onMouseUp);

    _container.querySelector("#undo").onClick.listen(_onClickUndo);
    _container.querySelector("#restart").onClick.listen(_onClickRestart);
    _container.querySelector("#new").onClick.listen(_onClickNew);
    _container.querySelector("#settings").onClick.listen(_onClickSettings);

    html.window.requestAnimationFrame(_update);
  }

  void _update(num highResTime) {
    if (_board.isGameOver) {
      _onGameOver();
    } else {
      html.window.requestAnimationFrame(_update);
    }

    _render();
  }

  void _onResize(html.Event event) {
    var ratio = 4 / 3;
    var width = html.window.innerWidth * 0.98;
    var height = html.window.innerHeight * 0.98;

    if ((width / height) > ratio) {
      width = height * ratio;
    } else {
      height = width / ratio;
    }

    if ((width < MIN_WIDTH) || (height < MIN_HEIGHT)) {
      width = MIN_WIDTH;
      height = MIN_HEIGHT;
    }

    _canvas.width = width.toInt();
    _canvas.height = height.toInt();

    _container.style.width = "${_canvas.width}px";
    _container.style.height = "${_canvas.height}px";
    _container.style.marginLeft = "${-_canvas.width ~/ 2}px";
    _container.style.marginTop = "${-_canvas.height ~/ 2}px";

    _render();
  }

  void _onClick(html.MouseEvent event) {
    if (_lastClick.elapsedMilliseconds > 250) {
      var clicked = _hovered(event);
      if (clicked is Pile) {
        _board.clickPile(clicked);
      } else if (clicked is Card) {
        _board.clickCard(clicked);
      }
    }
    _lastClick.reset();
  }

  void _onDoubleClick(html.MouseEvent event) {
    var clicked = _hovered(event);
    if (clicked is Card) {
      _board.doubleClickCard(clicked);
    }
  }

  void _onDragStart(html.MouseEvent event) {
    if (event.button == 0) {
      var dragged = _hovered(event);
      if (dragged is Card) {
        _board.dragStart(dragged, event.offset.x, event.offset.y);
      }
    }
    event.preventDefault();
  }

  void _onMouseMove(html.MouseEvent event) {
    _board.mouseMove(event.page.x - _container.offsetLeft, event.page.y - _container.offsetTop);

    var hovered;
    if (identical(event.target as html.Element, _canvas)) {
      hovered = _hovered(event);
      _renderer.hover(hovered);
    }

    _container.style.cursor = hovered == null ? "auto" : hovered.cursor;
  }

  void _onMouseUp(html.MouseEvent event) {
    _board.mouseUp();
  }

  void _onClickUndo(html.MouseEvent event) {
    _board.undo();
  }

  void _onClickRestart(html.MouseEvent event) {
    var messageBox = new MessageBox("Do you want to restart the current game?");

    messageBox.addButton("Yes", () {
      _restart();

      messageBox.close();
    });

    messageBox.addButton("No", () {
      messageBox.close();
    });

    messageBox.open();
  }

  void _onClickNew(html.MouseEvent event) {
    var messageBox = new MessageBox("Do you want to start a new game?");

    messageBox.addButton("Yes", () {
      _newGame();

      messageBox.close();
    });

    messageBox.addButton("No", () {
      messageBox.close();
    });

    messageBox.open();
  }

  void _onClickSettings(html.MouseEvent event) {
    var dialog = new SettingsDialog();

    dialog.addDrawOptions(_settings.cardsToDraw);
    dialog.addBackgroundOptions(_settings.backgroundImage);
    dialog.addFrontOptions(_settings.frontImage);

    dialog.addButton("Apply", () {
      _settings.cardsToDraw = dialog.getDraw();
      _settings.backgroundImage = dialog.getBackground();
      _settings.frontImage = dialog.getFront();
      _settings.save();

      dialog.close();
    });

    dialog.addButton("Cancel", () {
      dialog.close();
    });

    dialog.open();
  }

  void _onGameOver() {
    var gameover = new GameOver();
    var bouncer = new Bouncer(_board.bouncingCards());

    gameover.onUpdate = (num highResTime) {
      html.window.requestAnimationFrame(gameover.onUpdate);

      bouncer.update();
    };

    gameover.onClick = () {
      html.window.requestAnimationFrame(_update);

      bouncer.stop();

      _newGame();

      gameover.close();
    };

    gameover.open();

    bouncer.start();

    html.window.requestAnimationFrame(gameover.onUpdate);
  }

  Sprite _hovered(html.MouseEvent event) =>
    _renderer.hovered(event.offset.x, event.offset.y);
}
