import '../../models/economy/bank_account.dart';
import '../../models/person/character.dart';
import '../../models/work/business.dart';

class BusinessService {
  static void createCompany(Character owner, String name, String industry, double capital) {
    final company = Business(
      name: name,
      industry: industry,
      capital: capital,
      properties: [],
      employees: [], country: owner.country,
    );

    owner.businesses.add(company);

    // Création compte bancaire entreprise
    final businessAccount = BankAccount.createAccount(
      country: owner.country,
      bankName: 'BNP Paribas',
      type: AccountType.business,
      initialDeposit: capital,
    );

    owner.bankAccounts.add(businessAccount);
  }

  static void hireEmployee(Business company, Character employee, double salary) {
    if (company.capital >= salary * 3) {
      company.employees.add(Employee(
        name: employee.fullName,
        position: 'Employé',
        salary: salary,
      ));
      company.capital -= salary;
    }
  }

  static void takeBusinessLoan(Business company, double amount, int termYears) {
    final loan = BusinessLoan(
      businessId: company.id,
      amount: amount,
      interestRate: _getLoanRate(company.country),
      termMonths: termYears * 12,
    );

    company.loans.add(loan);
    company.capital += amount;
  }

  static double _getLoanRate(String country) {
    // Logique de taux selon pays
    return 3.5;
  }
}
