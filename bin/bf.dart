import 'package:bf/bf.dart';

void main(List<String> arguments) {
  final i = Interpreter();

  i.loadString(arguments[0]);
  i.execute();

  print('Cell pointer dump: ' + i.runtime.pointer.toString());
  print('First 10 cells dump: ' + i.runtime.memory.getRange(0, 10).join(', '));
}
