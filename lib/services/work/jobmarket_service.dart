import 'dart:convert';
import 'package:flutter/services.dart';

class JobMarketService {
  List<MarketJob> availableJobs = [];

  Future<void> loadJobs() async {
    String data = await rootBundle.loadString('assets/jobs.json');
    Map<String, dynamic> jsonResult = jsonDecode(data);

    availableJobs = (jsonResult['jobs'] as List<dynamic>).map((jobJson) {
      return MarketJob.fromJson(jobJson);
    }).toList();
  }
}

class MarketJob {
  String employerName;
  String jobTitle;
  int yearsRequired;
  String educationRequired;
  double annualSalary;
  double monthlySalary;
  String jobType;

  MarketJob({
    required this.employerName,
    required this.jobTitle,
    required this.yearsRequired,
    required this.educationRequired,
    required this.annualSalary,
    required this.monthlySalary,
    required this.jobType,
  });

  factory MarketJob.fromJson(Map<String, dynamic> json) {
    return MarketJob(
      employerName: json['employerName'],
      jobTitle: json['jobTitle'],
      yearsRequired: json['yearsRequired'],
      educationRequired: json['educationRequired'],
      annualSalary: json['annualSalary'].toDouble(),
      monthlySalary: json['monthlySalary'].toDouble(),
      jobType: json['jobType'],
    );
  }
}
