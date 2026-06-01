class Announcement {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final DateTime? startsAt;
  final DateTime? endsAt;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.startsAt,
    this.endsAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startsAt: json['startsAt'] != null ? DateTime.parse(json['startsAt'] as String) : null,
      endsAt: json['endsAt'] != null ? DateTime.parse(json['endsAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'startsAt': startsAt?.toIso8601String(),
      'endsAt': endsAt?.toIso8601String(),
    };
  }
}
