
import '../Classes/person.dart';

class JusticeService {
  void defendInCourt(Person person, String crime) {
    // Logique pour gérer la défense devant la justice
    bool verdict = _getVerdict();
    if (verdict) {
      print('${person.name} was found not guilty of $crime.');
    } else {
      print('${person.name} was found guilty of $crime.');
    }
  }

  bool _getVerdict() {
    // Simplified random verdict for the sake of example
    return DateTime.now().second % 2 == 0;
  }
}
