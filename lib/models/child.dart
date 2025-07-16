class Child {
  final int? id; // Nullable for new child
  final String childName;
  final DateTime playDate;
  final String phoneNumber;
  final int cost;
  final int? userId; // Nullable for new child

  Child({
    this.id,
    required this.childName,
    required this.playDate,
    required this.phoneNumber,
    required this.cost,
    this.userId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      childName: json['child_name'],
      playDate: DateTime.parse(json['play_date']),
      phoneNumber: json['phone_number'],
      cost: int.parse(json['cost'].toString()), // Ensure cost is int
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_name': childName,
      'play_date': playDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
      'phone_number': phoneNumber,
      'cost': cost,
      'user_id': userId,
    };
  }
}