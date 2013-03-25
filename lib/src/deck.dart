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

class Deck {
  static const num NUM_CARDS = 52;
  static const num NUM_SUITS = 4;
  static const num NUM_CARDS_BY_SUIT = NUM_CARDS ~/ NUM_SUITS;

  final List<Card> _cards = new List<Card>(NUM_CARDS);

  Deck() {
    _populateCards();
  }

  void _populateCards() {
    var pivot = 0;
    for (var suit = 0; suit < NUM_SUITS; ++ suit) {
      var color = suit % 2;
      for (var number = 1; number <= NUM_CARDS_BY_SUIT; ++ number) {
        _cards[pivot ++] = new Card(suit, number, color);
      }
    }
  }

  List<Card> get cards => _cards;

  void shuffle(int seed) {
    var random = new math.Random(seed);

    for (var i = 0; i < _cards.length; ++ i) {
      _swapCards(i, random.nextInt(_cards.length));
    }
  }

  void _swapCards(int i, int j) {
    var tmp = _cards[i];
    _cards[i] = _cards[j];
    _cards[j] = tmp;
  }
}
