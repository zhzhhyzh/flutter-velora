import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String companyName;
  final String companyLogo;
  final String title;
  final String location;
  final String description;
  final List<String> requirements;
  final DateTime postedDate;

  JobModel({
    required this.id,
    required this.companyName,
    this.companyLogo = '',
    required this.title,
    required this.location,
    required this.description,
    this.requirements = const [],
    required this.postedDate,
  });

  factory JobModel.fromMap(Map<String, dynamic> data) {
    return JobModel(
      id: data['id'] ?? '',
      companyName: data['companyName'] ?? '',
      companyLogo: data['companyLogo'] ?? '',
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
      postedDate: (data['postedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'title': title,
      'location': location,
      'description': description,
      'requirements': requirements,
      'postedDate': postedDate,
    };
  }
}