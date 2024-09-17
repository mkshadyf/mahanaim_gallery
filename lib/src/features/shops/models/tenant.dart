class Tenant {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  bool isOccupying;
  DateTime? moveInDate;
  int paymentStrikes;
  int contractLength; // in months
  List<Notification> notifications; // List of notifications

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isOccupying = false,
    this.moveInDate,
    this.paymentStrikes = 0,
    required this.contractLength,
    this.notifications = const [],
  });

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isOccupying: map['isOccupying'] ?? false,
      moveInDate:
          map['moveInDate'] != null ? DateTime.parse(map['moveInDate']) : null,
      paymentStrikes: map['paymentStrikes'] ?? 0,
      contractLength: map['contractLength'],
      notifications: (map['notifications'] as List<dynamic>?)
              ?.map((notification) => Notification.fromMap(notification))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOccupying': isOccupying,
      'moveInDate': moveInDate?.toIso8601String(),
      'paymentStrikes': paymentStrikes,
      'contractLength': contractLength,
      'notifications':
          notifications.map((notification) => notification.toMap()).toList(),
    };
  }
}

class Notification {
  final String id;
  final String message;
  final DateTime date;

  Notification({
    required this.id,
    required this.message,
    required this.date,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      message: map['message'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'date': date.toIso8601String(),
    };
  }
}
