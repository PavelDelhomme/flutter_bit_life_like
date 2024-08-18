
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/pnj_service.dart';

class FamilyService {
  final PnjService pnjService = PnjService();

  List<Person> generateFamily(String country) {
    return pnjService.generateFamily(country);
  }
}