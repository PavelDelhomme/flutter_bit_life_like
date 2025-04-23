import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/pnj_manager.dart';

class NPCManager {
  final List<Character> allNPCs = [];

  void generateInitialNPCs() {
    for (int i = 0; i < 100; i++) {
      allNPCs.add(PnjManager.generatePNJ());
    }
  }

  void updateNPCs(int year) {
    for (var npc in allNPCs) {
      if (!npc.isAlive) continue;
      npc.ageUp();
    }
  }

  List<Character> charactersNearPlayer(Character player) {
    return allNPCs.where((npc) => npc.city == player.city).toList();
  }
}