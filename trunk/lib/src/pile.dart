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

abstract class Pile extends TokenSprite {
  final List<Card> _cards = new List<Card>();

  Pile() {
    alpha = 0.75;
  }

  void activate(bool active) {
    alpha = active ? 1.0 : 0.75;
  }

  Image get spriteSheet => _settings.pileImage;

  bool get isEmpty => _cards.isEmpty;
  int get length => _cards.length;
  Card get bottom => _cards.first;
  Card get top => _cards.last;

  Sprite get topContainer => isEmpty ? this : top;

  void clear() {
    _cards.clear();
  }

  bool accept(Card card) => true;

  void push(Card card) {
    _cards.add(card);

    card.pile = this;
    card.z = _cards.length;

    _stack(card);
  }

  Card pop([Card card]) {
    card = card != null ? card : top;

    _cards.removeAt(_cards.indexOf(card));

    return card;
  }

  bool canDrag(Card card) => card.isFaceUp;

  List<Card> drag(Card card) => _cards.sublist(_cards.indexOf(card));

  void _stack(Card card) {
    card.offsetTo(this, 0, 0);
  }
}

/**
 * Stock pile implementation.
 */
class Stock extends Pile {

  Stock() : super() {
    rx = 0.03;
    ry = 0.03;

    cursor = "pointer";
  }

  void push(Card card) {
    card.faceDown();

    super.push(card);
  }

  void _stack(Card card) {
    card.offsetTo(this, 0.00025 * (_cards.length - 1), 0.0005 * (_cards.length - 1));
  }
}

/**
 * Waste pile implementation.
 */
class Waste extends Pile {

  Waste() : super() {
    ox = ow;
    rx = 0.17;
    ry = 0.03;
  }

  void push(Card card) {
    card.faceUp();

    super.push(card);
  }
}

/**
 * Draw pile implementation.
 */
class Draw extends Pile {

  Draw() : super() {
    ox = ow;
    rx = 0.17;
    ry = 0.03;
  }

  void push(Card card) {
    card.faceUp();

    super.push(card);

    card.z += Deck.NUM_CARDS;
  }

  bool canDrag(Card card) => identical(card, top);

  void _stack(Card card) {
    card.offsetTo(this, 0.025 * (_cards.length - 1), 0);
  }
}

/**
 * Column pile implementation.
 */
class Column extends Pile {

  Column(num order) : super() {
    ox = 2 * ow;
    rx = 0.03 + (0.14 * order);
    ry = 0.30;
  }

  bool accept(Card card) =>
    isEmpty
      ? card.number == Deck.NUM_CARDS_BY_SUIT
      : (card.color != top.color) && (card.number == top.number - 1);

  void _stack(Card card) {
    var offset = 0.0;
    for (var i = 0; i < _cards.length - 1; ++ i) {
      offset += _cards[i].isFaceUp ? 0.035: 0.015;
    }
    card.offsetTo(this, 0, offset);
  }
}

/**
 * Foundation pile implementation.
 */
class Foundation extends Pile {

  Foundation(num order) : super() {
    ox = 3 * ow;
    rx = 0.45 + (0.14 * order);
    ry = 0.03;
  }

  bool accept(Card card) =>
    isEmpty
      ? card.number == 1
      : (card.suit == top.suit) && (card.number == top.number + 1);
}
