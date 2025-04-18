class SimulationManager {
  final List<Function(int)> _tasks = [];

  void registerTask(Function(int year) task) {
    _tasks.add(task);
  }

  void startBackgroundSimulation() {
    // TODO: lancer en tâche de fond si besoin
  }

  void processYear(int year) {
    for (final task in _tasks) {
      task(year);
    }
  }
}