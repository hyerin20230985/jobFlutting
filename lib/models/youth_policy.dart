class YouthPolicy {
  final String id;
  final String title;
  final String organization;
  final String description;
  final String target;
  final String supportAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;

  YouthPolicy({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.target,
    required this.supportAmount,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
  });

  factory YouthPolicy.fromJson(Map<String, dynamic> json) {
    return YouthPolicy(
      id: json['id'],
      title: json['title'],
      organization: json['organization'],
      description: json['description'],
      target: json['target'],
      supportAmount: json['supportAmount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'organization': organization,
      'description': description,
      'target': target,
      'supportAmount': supportAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'category': category,
    };
  }
}
