class Tenant {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  bool isOccupying; // New field for occupancy status
  DateTime? moveInDate; // New field for move-in date
  int paymentStrikes; // New field for payment strikes

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isOccupying = false, // Initialize occupancy status
    this.moveInDate, // Initialize move-in date
    this.paymentStrikes = 0, // Initialize payment strikes
  });

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isOccupying: map['isOccupying'] ?? false, // Get occupancy status from map
      moveInDate: map['moveInDate'] != null ? DateTime.parse(map['moveInDate']) : null, // Get move-in date from map
      paymentStrikes: map['paymentStrikes'] ?? 0, // Get payment strikes from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOccupying': isOccupying, // Add occupancy status to map
      'moveInDate': moveInDate?.toIso8601String(), // Add move-in date to map
      'paymentStrikes': paymentStrikes, // Add payment strikes to map
    };
  }
}