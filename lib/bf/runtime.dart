class Runtime {
  int pointer;
  List<int> memory;

  Runtime()
      : pointer = 0,
        memory = [for (int i = 0; i < 30000; i++) 0];
}
