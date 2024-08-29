class Tenant {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final List<Payment> payments;
  final DateTime contractStartDate;
  final DateTime contractEndDate;
  final double monthlyRent;
  final double leaseFee;

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.payments,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.monthlyRent,
    required this.leaseFee,
  });

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      payments: (map['payments'] as List).map((p) => Payment.fromMap(p)).toList(),
      contractStartDate: DateTime.parse(map['contractStartDate']),
      contractEndDate: DateTime.parse(map['contractEndDate']),
      monthlyRent: map['monthlyRent'],
      leaseFee: map['leaseFee'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'payments': payments.map((p) => p.toMap()).toList(),
      'contractStartDate': contractStartDate.toIso8601String(),
      'contractEndDate': contractEndDate.toIso8601String(),
      'monthlyRent': monthlyRent,
      'leaseFee': leaseFee,
    };
  }
}

class Payment {
  final DateTime date;
  final double amount;
  final String type;

  Payment({required this.date, required this.amount, required this.type});

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'type': type,
    };
  }
}
