import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final String shopId;
  final String tenantId;
  final DateTime date;
  final double amount;
  final PaymentType paymentType;
  final int month;

  Payment({
    required this.id,
    required this.shopId,
    required this.tenantId,
    required this.date,
    required this.amount,
    required this.paymentType,
    required this.month,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      shopId: map['shopId'],
      tenantId: map['tenantId'],
      date: (map['date'] as Timestamp).toDate(),
      amount: map['amount'].toDouble(),
      paymentType: PaymentType.values.byName(map['paymentType']),
      month: map['month'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopId': shopId,
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
