// models/career.dart
import 'dart:math';

import 'package:bitlife_like/models/person/skill.dart';

enum EducationLevel {
  none,
  primarySchool,
  middleSchool,
  highSchool,
  associateDegree,
  bachelorDegree,
  masterDegree,
  doctorate
}

enum EmploymentStatus {
  unemployed,
  partTime,
  fullTime,
  retired,
  onLeave,
  fired,
  entrepreneur
}


class Career {
  final String id;
  final String characterId;
  String companyName;
  String jobTitle;
  int yearsInPosition;
  double salary;
  double bonusRate;
  EmploymentStatus status;
  double performanceRating; // 0.0 à 1.0
  double stressLevel; // 0.0 à 1.0
  int workHoursPerWeek;
  List<Skill> skills;
  EducationLevel educationLevel;
  List<String> certifications;
  List<String> previousJobs;
  bool isInProbation;
  DateTime? retirementDate;
  double retirementBenefits;
  int vacationDaysRemaining;
  double taxRate;
  
  Career({
    required this.id,
    required this.characterId,
    required this.companyName,
    required this.jobTitle,
    this.yearsInPosition = 0,
    required this.salary,
    this.bonusRate = 0.0,
    this.status = EmploymentStatus.unemployed,
    this.performanceRating = 0.5,
    this.stressLevel = 0.3,
    this.workHoursPerWeek = 40,
    List<Skill>? skills,
    this.educationLevel = EducationLevel.none,
    List<String>? certifications,
    List<String>? previousJobs,
    this.isInProbation = true,
    this.retirementDate,
    this.retirementBenefits = 0.0,
    this.vacationDaysRemaining = 0,
    this.taxRate = 0.2,
  }) : 
    skills = skills ?? [],
    certifications = certifications ?? [],
    previousJobs = previousJobs ?? [];
  
  double calculateMonthlyIncome() {
    if (status == EmploymentStatus.unemployed || status == EmploymentStatus.fired) {
      return 0.0;
    } else if (status == EmploymentStatus.retired) {
      return retirementBenefits;
    } else if (status == EmploymentStatus.partTime) {
      return salary * 0.5;
    } else {
      return salary + (salary * bonusRate * performanceRating);
    }
  }
  
  double calculateAnnualIncome() {
    return calculateMonthlyIncome() * 12;
  }
  
  double calculateNetMonthlyIncome() {
    return calculateMonthlyIncome() * (1 - taxRate);
  }
  
  void askForRaise() {
    // Logique pour demander une augmentation
    double chanceOfSuccess = performanceRating * 0.7 + (yearsInPosition * 0.05);
    if (chanceOfSuccess > 0.7) {
      // Succès avec une augmentation de 5-15%
      double increaseRate = 0.05 + (Random().nextDouble() * 0.1);
      salary *= (1 + increaseRate);
    }
  }
  
  void receivePromotion(String newTitle, double salaryCap) {
    previousJobs.add(jobTitle);
    jobTitle = newTitle;
    yearsInPosition = 0;
    
    // Augmentation de salaire avec promotion (10-30%)
    double increaseRate = 0.1 + (Random().nextDouble() * 0.2);
    double newSalary = salary * (1 + increaseRate);
    
    // S'assurer que le nouveau salaire ne dépasse pas le plafond
    salary = newSalary < salaryCap ? newSalary : salaryCap;
    
    // Reset probation
    isInProbation = true;
  }
  
  void workHarder() {
    performanceRating = (performanceRating + 0.05).clamp(0.0, 1.0);
    stressLevel = (stressLevel + 0.1).clamp(0.0, 1.0);
  }
  
  void takeVacation(int days) {
    if (vacationDaysRemaining >= days) {
      vacationDaysRemaining -= days;
      stressLevel = (stressLevel - 0.1 * days / 7).clamp(0.0, 1.0);
    }
  }
  
  void retire() {
    status = EmploymentStatus.retired;
    retirementDate = DateTime.now();
    
    // Calcul des avantages de retraite
    double yearsWorked = (previousJobs.length + yearsInPosition) as double;
    retirementBenefits = salary * 0.6 * (yearsWorked / 30).clamp(0.0, 1.0);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'yearsInPosition': yearsInPosition,
      'salary': salary,
      'bonusRate': bonusRate,
      'status': status.toString(),
      'performanceRating': performanceRating,
      'stressLevel': stressLevel,
      'workHoursPerWeek': workHoursPerWeek,
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'educationLevel': educationLevel.toString(),
      'certifications': certifications,
      'previousJobs': previousJobs,
      'isInProbation': isInProbation,
      'retirementDate': retirementDate?.toIso8601String(),
      'retirementBenefits': retirementBenefits,
      'vacationDaysRemaining': vacationDaysRemaining,
      'taxRate': taxRate,
    };
  }
  
  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      characterId: json['characterId'],
      companyName: json['companyName'],
      jobTitle: json['jobTitle'],
      yearsInPosition: json['yearsInPosition'],
      salary: json['salary'],
      bonusRate: json['bonusRate'],
      status: EmploymentStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => EmploymentStatus.unemployed,
      ),
      performanceRating: json['performanceRating'],
      stressLevel: json['stressLevel'],
      workHoursPerWeek: json['workHoursPerWeek'],
      skills: (json['skills'] as List)
          .map((skill) => Skill.fromJson(skill))
          .toList(),
      educationLevel: EducationLevel.values.firstWhere(
        (e) => e.toString() == json['educationLevel'],
        orElse: () => EducationLevel.none,
      ),
      certifications: List<String>.from(json['certifications']),
      previousJobs: List<String>.from(json['previousJobs']),
      isInProbation: json['isInProbation'],
      retirementDate: json['retirementDate'] != null
          ? DateTime.parse(json['retirementDate'])
          : null,
      retirementBenefits: json['retirementBenefits'],
      vacationDaysRemaining: json['vacationDaysRemaining'],
      taxRate: json['taxRate'],
    );
  }
}
