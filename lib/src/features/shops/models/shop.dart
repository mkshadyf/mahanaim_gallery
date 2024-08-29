class Shop {
  final String id;
  final String name;
  final String description;
  final List<String> tenantIds;
  final DateTime dateCreated;
  final double rentAmount;
  final bool isAvailable;
  final DateTime? nextAvailableDate;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.tenantIds,
    required this.dateCreated,
    required this.rentAmount,
    required this.isAvailable,
    this.nextAvailableDate,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      tenantIds: List<String>.from(map['tenantIds']),
      dateCreated: DateTime.parse(map['dateCreated']),
      rentAmount: map['rentAmount'],
      isAvailable: map['isAvailable'],
      nextAvailableDate: map['nextAvailableDate'] != null ? DateTime.parse(map['nextAvailableDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tenantIds': tenantIds,
      'dateCreated': dateCreated.toIso8601String(),
      'rentAmount': rentAmount,
      'isAvailable': isAvailable,
      'nextAvailableDate': nextAvailableDate?.toIso8601String(),
    };
  }
}
