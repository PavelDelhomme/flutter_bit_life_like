import 'dart:convert';
import 'package:flutter/services.dart';

class JobMarketService {
  List<Job> availableJobs = [];

  Future<void> loadJobs() async {
    String data = await rootBundle.loadString('assets/jobs.json');
    Map<String, dynamic> jsonResult = jsonDecode(data);

    availableJobs = (jsonResult['jobs'] as List<dynamic>).map((jobJson) {
      return Job.fromJson(jobJson);
    }).toList();
  }
}

class Job {
  String employerName;
  String jobTitle;
  int yearsRequired;
  String educationRequired;
  double annualSalary;
  double monthlySalary;
  String jobType;

  Job({
    required this.employerName,
    required this.jobTitle,
    required this.yearsRequired,
    required this.educationRequired,
    required this.annualSalary,
    required this.monthlySalary,
    required this.jobType,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
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
