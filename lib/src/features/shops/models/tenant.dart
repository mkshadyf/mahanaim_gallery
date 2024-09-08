import '../../notifications/models/notificationsettings.dart';

class Tenant {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime contractStartDate;
  final DateTime contractEndDate;
  String? assignedShopId;
  NotificationSettings notificationSettings;
  int leaseViolations;
  String preferredCommunicationMethod;
  DateTime? _lastPaymentDate;

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.contractStartDate,
    required this.contractEndDate,
    this.assignedShopId,
    this.notificationSettings = const NotificationSettings(),
    this.leaseViolations = 0,
    this.preferredCommunicationMethod = 'email',
    DateTime? lastPaymentDate,
  }) : _lastPaymentDate = lastPaymentDate;

  DateTime? get lastPaymentDate => _lastPaymentDate;

  void updateLastPaymentDate(DateTime date) {
    _lastPaymentDate = date;
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      contractStartDate: DateTime.parse(map['contractStartDate']),
      contractEndDate: DateTime.parse(map['contractEndDate']),
      assignedShopId: map['assignedShopId'],
      leaseViolations: map['leaseViolations'] ?? 0,
      preferredCommunicationMethod: map['preferredCommunicationMethod'] ?? 'email',
      lastPaymentDate: map['lastPaymentDate'] != null ? DateTime.parse(map['lastPaymentDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'contractStartDate': contractStartDate.toIso8601String(),
      'contractEndDate': contractEndDate.toIso8601String(),
      'assignedShopId': assignedShopId,
      'leaseViolations': leaseViolations,
      'preferredCommunicationMethod': preferredCommunicationMethod,
      'lastPaymentDate': _lastPaymentDate?.toIso8601String(),
    };
  }
}
