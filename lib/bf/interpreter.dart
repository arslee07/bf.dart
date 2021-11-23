import 'package:bf/bf.dart';

class Interpreter {
  final Runtime runtime;
  List<Instruction> _instructions;

  Interpreter()
      : runtime = Runtime(),
        _instructions = [];

  void loadString(String input) {
    _instructions = _parseString(input);
  }

  void clear(String input) {
    _instructions = [];
    runtime.pointer = 0;
    runtime.memory = [for (int i = 0; i < 30000; i++) 0];
  }

  void execute() {
    for (final i in _instructions) {
      i.execute();
    }
    _instructions = [];
  }

  List<Instruction> _parseString(String input) {
    int brackets = 0;
    int startBlock = 0;
    List<Instruction> res = [];
    for (int i = 0; i < input.length; i++) {
      switch (input[i]) {
        case '+':
          res.add(IncrementInstruction(runtime));
          break;
        case '-':
          res.add(DecrementInstruction(runtime));
          break;
        case '>':
          res.add(ShiftRightInstruction(runtime));
          break;
        case '<':
          res.add(ShiftLeftInstruction(runtime));
          break;
        case ',':
          res.add(GetCharInstruction(runtime));
          break;
        case '.':
          res.add(PutCharInstruction(runtime));
          break;
        case '[':
          if (brackets == 0) {
            startBlock = i;
          }
          brackets += 1;
          break;
        case ']':
          if (brackets <= 0) {
            throw AssertionError('Unmatched bracket');
          }
          brackets -= 1;
          if (brackets == 0) {
            res.add(
              LoopInstruction(
                runtime,
                _parseString(input.substring(startBlock + 1, i)),
              ),
            );
          }
          break;
      }
    }

    if (brackets != 0) {
      throw AssertionError('Unmatched bracket');
    }
    return res;
  }
}
