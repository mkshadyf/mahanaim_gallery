import 'package:mahanaim_gallery/src/features/shops/models/tenant.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  final double rentAmount;
  final double leaseAmount; // New field for lease amount
  final DateTime? leasePaymentDate; // New field for lease payment date
  final List<RentPayment> rentPayments;
  bool isOccupied; // New field for occupancy status
  final DateTime? nextAvailableDate;
  Tenant? tenant;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.rentAmount,
    required this.leaseAmount, // Initialize lease amount
    this.leasePaymentDate, // Initialize lease payment date
    required this.rentPayments,
    this.isOccupied = false, // Initialize occupancy status
    this.nextAvailableDate,
    this.tenant,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      rentAmount: map['rentAmount'],
      leaseAmount: map['leaseAmount'] ?? 0.0, // Get lease amount from map
      leasePaymentDate: map['leasePaymentDate'] != null ? DateTime.parse(map['leasePaymentDate']) : null, // Get lease payment date from map
      rentPayments: (map['rentPayments'] as List?)?.map((p) => RentPayment.fromMap(p)).toList() ?? [],
      isOccupied: map['isOccupied'] ?? false, // Get occupancy status from map
      nextAvailableDate: map['nextAvailableDate'] != null ? DateTime.parse(map['nextAvailableDate']) : null,
      tenant: map['tenant'] != null ? Tenant.fromMap(map['tenant']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rentAmount': rentAmount,
      'leaseAmount': leaseAmount, // Add lease amount to map
      'leasePaymentDate': leasePaymentDate?.toIso8601String(), // Add lease payment date to map
      'rentPayments': rentPayments.map((p) => p.toMap()).toList(),
      'isOccupied': isOccupied, // Add occupancy status to map
      'nextAvailableDate': nextAvailableDate?.toIso8601String(),
      'tenant': tenant?.toMap(),
    };
  }

  double getTotalRentPaid() {
    return rentPayments.fold(0, (sum, payment) => sum + payment.amount);
  }

  double getTotalRentDue() {
    return rentAmount * rentPayments.length - getTotalRentPaid();
  }

  String getPaymentStatus() {
    if (rentPayments.isEmpty) return 'No payments';
    final lastPayment = rentPayments.last;
    final now = DateTime.now();
    if (lastPayment.date.month == now.month && lastPayment.date.year == now.year) {
      return 'Up-to-date';
    }
    return 'Overdue';
  }

  bool isPaymentOverdue() {
    if (rentPayments.isEmpty) return true;
    final lastPayment = rentPayments.last;
    final now = DateTime.now();
    return lastPayment.date.isBefore(DateTime(now.year, now.month, 1));
  }
}

class RentPayment {
  final String tenantId;
  final DateTime date;
  final double amount;
  final PaymentType paymentType; // New field for payment type
  final int month; // New field for month of payment

  RentPayment({
    required this.tenantId,
    required this.date,
    required this.amount,
    required this.paymentType, // Initialize payment type
    required this.month, // Initialize month of payment
  });

  factory RentPayment.fromMap(Map<String, dynamic> map) {
    return RentPayment(
      tenantId: map['tenantId'],
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      paymentType: PaymentType.values.byName(map['paymentType']), // Get payment type from map
      month: map['month'], // Get month of payment from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tenantId': tenantId,
      'date': date.toIso8601String(),
      'amount': amount,
      'paymentType': paymentType.name, // Add payment type to map
      'month': month, // Add month of payment to map
    };
  }
}

enum PaymentType { lease, rent }