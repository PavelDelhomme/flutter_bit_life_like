import '../../Classes/person.dart';

class CarceralService {
  void imprison(Person person, double debtAmount) {
    int prisonTerm = calculatePrisonTerm(debtAmount);
    print("${person.name} has been imprisoned for $prisonTerm years due to unpaid debts of \$${debtAmount}.");
    person.isImprisoned = true;
    person.prisonTerm = prisonTerm;
  }

  int calculatePrisonTerm(double debtAmount) {
    // La durée de la peine est proportionnelle au montant impayé
    return (debtAmount / 100000).ceil();  // 1 an par tranche de 100000 non payée
  }

  void releaseFromPrison(Person person) {
    if (person.prisonTerm <= 0) {
      person.isImprisoned = false;
      print("${person.name} has been released from prison.");
    } else {
      print("${person.name} is still serving time.");
    }
  }
}
