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

class Board {
  final Pile _stock = new Stock();
  final Pile _waste = new Waste();
  final Pile _draw = new Draw();
  final List<Pile> _columns = new List<Pile>.fixedLength(7);
  final List<Pile> _foundations = new List<Pile>.fixedLength(4);
  final List<Drag> _dragged = new List<Drag>();
  final Commander _commander = new Commander();

  Board() {
    _populateColumns();
    _populateFoundations();
  }

  void _populateColumns() {
    for (var i = 0; i < _columns.length; ++ i) {
      _columns[i] = new Column(i);
    }
  }

  void _populateFoundations() {
    for (var i = 0; i < _foundations.length; ++ i) {
      _foundations[i] = new Foundation(i);
    }
  }

  List<Pile> get piles => new List<Pile>()
      ..add(_stock)
      ..add(_waste)
      ..add(_draw)
      ..addAll(_columns)
      ..addAll(_foundations);

  void clear() {
    _stock.clear();
    _waste.clear();
    _draw.clear();
    _columns.forEach((column) => column.clear());
    _foundations.forEach((foundation) => foundation.clear());
    _dragged.clear();
    _commander.clear();
  }

  void deal(List<Card> cards) {
    cards.forEach((card) => _stock.push(card));

    for (var i = 0; i < _columns.length; ++ i) {
      for (var j = 0; j <= i; ++ j) {
        _columns[i].push(_stock.pop());
      }
      _columns[i].top.faceUp();
    }
  }

  void clickPile(Pile pile) {
    if (identical(pile, _stock)) {
      var commands = new List<Command>();
      if (!_draw.isEmpty) {
        commands.add(new DragCommand(_draw, _waste, _draw.drag(_draw.bottom)));
      }
      if (!_draw.isEmpty || !_waste.isEmpty) {
        commands.add(new MoveCommand(_waste, _stock, _draw.length + _waste.length));
      }
      if (!commands.isEmpty) {
        _commander.execute(new UndoableCompositeCommand(commands));
      }
    }
  }

  void clickCard(Card card) {
    if (identical(card.pile, _stock)) {
      var commands = new List<Command>();
      if (!_draw.isEmpty) {
        commands.add(new DragCommand(_draw, _waste, _draw.drag(_draw.bottom)));
      }
      var times = math.min(_stock.length, _settings.cardsToDraw);
      commands.add(new MoveCommand(_stock, _draw, times));
      _commander.execute(new UndoableCompositeCommand(commands));
    }
  }

  void doubleClickCard(Card card) {
    var pile = card.pile;
    if ((pile is! Foundation) && identical(card, pile.top) && card.isFaceUp) {
      for (var foundation in _foundations) {
        if (foundation.accept(card)) {
          var commands = new List<Command>();
          commands.add(new MoveCommand(pile, foundation));
          if (pile is Column) {
            commands.add(new AutoFaceUpCommand(pile));
          }
          _commander.execute(new UndoableCompositeCommand(commands));
          break;
        }
      }
    }
  }

  void dragStart(Card card, int x, int y) {
    if (_dragged.isEmpty) {
      if (card.pile.canDrag(card)) {
        _dragged.addAll(card.pile.drag(card).map((card) => new Drag(card, x, y)));
      }
    }
  }

  void mouseMove(int x, int y) {
    _dragged.forEach((drag) => drag.moveTo(x, y));
  }

  void mouseUp() {
    if (!_dragged.isEmpty) {
      var card = _dragged.first.card;

      var target = _getDropTarget(card);
      if (target == null) {
        _dragged.forEach((drag) => drag.cancel());

      } else {
        var source = card.pile;
        var cards = _dragged.map((drag) => drag.card).toList();

        var commands = new List<Command>();
        commands.add(new DragCommand(source, target, cards));
        if (source is Column) {
          commands.add(new AutoFaceUpCommand(source));
        }
        _commander.execute(new UndoableCompositeCommand(commands));
      }

      _dragged.clear();
    }
  }

  bool get isGameOver =>
    _foundations.every((pile) => pile.length == Deck.NUM_CARDS_BY_SUIT);

  Iterator<Card> bouncingCards() {
    var cards = new List<Card>();
    while(!_foundations.last.isEmpty) {
      for (var foundation in _foundations) {
        cards.add(foundation.pop());
      }
    }
    return cards.iterator;
  }

  void undo() {
    _commander.undo();
  }

  Pile _getDropTarget(Card card){
    var piles = new List<Pile>.from(_foundations)..addAll(_columns);

    for (var pile in piles) {
      if (!identical(pile, card.pile)) {
        if (_intersects(pile.topContainer, card.x, card.y)) {
          if (pile.accept(card)) {
            return pile;
          }
        }
      }
    }

    return null;
  }

  bool _intersects(Sprite target, num x, num y) {
    return (x > target.x - (target.width * 0.5))
        && (x < target.x + (target.width * 0.75) )
        && (y > target.y - (target.height * 0.5))
        && (y < target.y + (target.height * 0.75));
  }
}
