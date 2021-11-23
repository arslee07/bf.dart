import 'dart:io';
import 'package:bf/bf.dart';

abstract class Instruction {
  final Runtime _runtime;
  Instruction(this._runtime);

  void execute();
}

class IncrementInstruction extends Instruction {
  IncrementInstruction(Runtime runtime) : super(runtime);

  @override
  void execute() {
    _runtime.memory[_runtime.pointer] =
        (_runtime.memory[_runtime.pointer] + 1) % 256;
  }
}

class DecrementInstruction extends Instruction {
  DecrementInstruction(Runtime runtime) : super(runtime);

  @override
  void execute() {
    _runtime.memory[_runtime.pointer] =
        (_runtime.memory[_runtime.pointer] - 1) % 256;
  }
}

class ShiftRightInstruction extends Instruction {
  ShiftRightInstruction(Runtime runtime) : super(runtime);

  @override
  void execute() {
    if (_runtime.pointer >= _runtime.memory.length) {
      throw OutOfMemoryError();
    }

    _runtime.pointer += 1;
  }
}

class ShiftLeftInstruction extends Instruction {
  ShiftLeftInstruction(Runtime runtime) : super(runtime);

  @override
  void execute() {
    if (_runtime.pointer <= 0) {
      throw OutOfMemoryError();
    }

    _runtime.pointer -= 1;
  }
}

class PutCharInstruction extends Instruction {
  PutCharInstruction(Runtime runtime) : super(runtime);

  @override
  void execute() {
    stdout.writeCharCode(_runtime.memory[_runtime.pointer]);
  }
}

class GetCharInstruction extends Instruction {
  GetCharInstruction(Runtime runtime) : super(runtime);

  @override
  void execute() {
    _runtime.memory[_runtime.pointer] = stdin.readByteSync();
  }
}

class LoopInstruction extends Instruction {
  final Iterable<Instruction> _body;

  LoopInstruction(Runtime runtime, this._body) : super(runtime);

  @override
  void execute() {
    while (_runtime.memory[_runtime.pointer] != 0) {
      for (var i in _body) {
        i.execute();
      }
    }
  }
}
