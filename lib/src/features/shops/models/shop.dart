import 'package:cloud_firestore/cloud_firestore.dart';

import 'tenant.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  Tenant? tenant;
  final DateTime dateCreated;
  final DateTime? contractEndDate;
  final int contractLength; // in months
  final double rentAmount;
  final double leaseAmount;
  final DateTime? leasePaymentDate;
  final List<RentPayment> rentPayments;
  final bool isOccupied;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    this.tenant,
    required this.dateCreated,
    this.contractEndDate,
    required this.contractLength,
    required this.rentAmount,
    required this.leaseAmount,
    this.leasePaymentDate,
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
      contractEndDate: map['contractEndDate'] != null
          ? (map['contractEndDate'] as Timestamp).toDate()
          : null,
      contractLength: map['contractLength'],
      rentAmount: map['rentAmount'].toDouble(),
      leaseAmount: map['leaseAmount'].toDouble(),
      leasePaymentDate: map['leasePaymentDate'] != null
          ? (map['leasePaymentDate'] as Timestamp).toDate()
          : null,
      rentPayments: (map['rentPayments'] as List<dynamic>?)
              ?.map((payment) => RentPayment.fromMap(payment))
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
      'contractEndDate':
          contractEndDate != null ? Timestamp.fromDate(contractEndDate!) : null,
      'contractLength': contractLength,
      'rentAmount': rentAmount,
      'leaseAmount': leaseAmount,
      'leasePaymentDate': leasePaymentDate != null
          ? Timestamp.fromDate(leasePaymentDate!)
          : null,
      'rentPayments': rentPayments.map((payment) => payment.toMap()).toList(),
      'isOccupied': isOccupied,
    };
  }

  bool get isShopOccupied => tenant != null;

  double getTotalRentPaid() {
    return rentPayments.fold(0, (sum, payment) => sum + payment.amount);
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

class RentPayment {
  final String tenantId;
  final DateTime date;
  final double amount;
  final PaymentType paymentType;
  final int month;

  RentPayment({
    required this.tenantId,
    required this.date,
    required this.amount,
    required this.paymentType,
    required this.month,
  });

  factory RentPayment.fromMap(Map<String, dynamic> map) {
    return RentPayment(
      tenantId: map['tenantId'],
      date: (map['date'] as Timestamp).toDate(),
      amount: map['amount'].toDouble(),
      paymentType: PaymentType.values.byName(map['paymentType']),
      month: map['month'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tenantId': tenantId,
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'paymentType': paymentType.name,
      'month': month,
    };
  }
}

enum PaymentType {
  rent,
  lease,
}
