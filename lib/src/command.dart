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

abstract class Command {
  void execute();
}

abstract class UndoableCommand extends Command {
  void undo();
}

abstract class TransientCommand extends Command {
}

class CompositeCommand implements Command {
  final List<Command> _commands;

  CompositeCommand(this._commands);

  void execute() {
    _commands.forEach((command) => command.execute());
  }
}

class UndoableCompositeCommand extends CompositeCommand implements UndoableCommand {

  UndoableCompositeCommand(List<Command> commands) : super(commands);

  void undo() {
    for (var i = _commands.length - 1; i >= 0; -- i) {
      (_commands[i] as UndoableCommand).undo();
    }
  }
}

class Commander {
  final List<UndoableCommand> _history = new List<UndoableCommand>();

  void execute(Command command) {
    command.execute();

    _register(command);
  }

  void undo() {
    if (!_history.isEmpty){
      _history.removeLast().undo();
    }
  }

  void clear() {
    _history.clear();
  }

  void _register(Command command) {
    if (command is! TransientCommand) {
      if (command is UndoableCommand) {
        _history.add(command);
      } else {
        clear();
      }
    }
  }
}

class MoveCommand implements UndoableCommand {
  final Pile _from;
  final Pile _to;
  final int _times;

  MoveCommand(this._from, this._to, [this._times = 1]);

  void execute() {
    for (var i = 0; i < _times; ++ i) {
      _to.push(_from.pop());
    }
  }

  void undo() {
    for (var i = 0; i < _times; ++ i) {
      _from.push(_to.pop());
    }
  }
}

class DragCommand implements UndoableCommand {
  final Pile _from;
  final Pile _to;
  final List<Card> _cards;

  DragCommand(this._from, this._to, this._cards);

  void execute() {
    _cards.forEach((card) {
      _to.push(_from.pop(card));
    });
  }

  void undo() {
    _cards.forEach((card) {
      _from.push(_to.pop(card));
    });
  }
}

class AutoFaceUpCommand implements UndoableCommand {
  final Pile _pile;

  bool _faceUp;

  AutoFaceUpCommand(this._pile);

  void execute() {
    if (!_pile.isEmpty) {
      _faceUp = _pile.top.isFaceUp;

      _pile.top.faceUp();
    }
  }

  void undo() {
    if (!_pile.isEmpty) {
      _faceUp ? _pile.top.faceUp() : _pile.top.faceDown();
    }
  }
}
