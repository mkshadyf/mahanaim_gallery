import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment.dart';
import 'tenant.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  Tenant? tenant;
  final DateTime dateCreated;
  final double rentAmount;
  final double leaseAmount;
  final List<Payment> rentPayments;
  final bool isOccupied;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    this.tenant,
    required this.dateCreated,
    required this.rentAmount,
    required this.leaseAmount,
    this.rentPayments = const [],
    required this.isOccupied,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      tenant: map['tenant'] != null ? Tenant.fromMap(map['tenant']) : null,
      dateCreated: (map['dateCreated'] as Timestamp).toDate(),
      rentAmount: map['rentAmount'].toDouble(),
      leaseAmount: map['leaseAmount'].toDouble(),
      rentPayments: (map['rentPayments'] as List<dynamic>?)
              ?.map((payment) => Payment.fromMap(payment))
              .toList() ??
          [],
      isOccupied: map['isOccupied'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tenant': tenant?.toMap(),
      'dateCreated': Timestamp.fromDate(dateCreated),
      'rentAmount': rentAmount,
      'leaseAmount': leaseAmount,
      'rentPayments': rentPayments.map((payment) => payment.toMap()).toList(),
      'isOccupied': isOccupied,
    };
  }

  bool get isShopOccupied => tenant != null;

  double getTotalRentPaid() {
    return rentPayments.fold(0, (total, payment) => total + payment.amount);
  }

  bool isPaymentOverdue() {
    if (rentPayments.isEmpty) {
      return true;
    }
    final lastPaymentDate = rentPayments.last.date;
    final nextPaymentDueDate = DateTime(
        lastPaymentDate.year, lastPaymentDate.month + 1, lastPaymentDate.day);
    return nextPaymentDueDate.isBefore(DateTime.now());
  }
}
