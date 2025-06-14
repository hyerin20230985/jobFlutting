class JobPosting {
  final String id;
  final String companyName;
  final String position;
  final String location;
  final String description;
  final String requirements;
  final String salary;
  final DateTime postedDate;
  final String category;
  final String detailUrl;

  JobPosting({
    required this.id,
    required this.companyName,
    required this.position,
    required this.location,
    required this.description,
    required this.requirements,
    required this.salary,
    required this.postedDate,
    required this.category,
    required this.detailUrl,
  });

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      id: json['id'],
      companyName: json['companyName'],
      position: json['position'],
      location: json['location'],
      description: json['description'],
      requirements: json['requirements'],
      salary: json['salary'],
      postedDate: DateTime.parse(json['postedDate']),
      category: json['category'],
      detailUrl: json['detailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'position': position,
      'location': location,
      'description': description,
      'requirements': requirements,
      'salary': salary,
      'postedDate': postedDate.toIso8601String(),
      'category': category,
      'detailUrl': detailUrl,
    };
  }
}
