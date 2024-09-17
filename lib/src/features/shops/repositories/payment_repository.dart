import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/payment.dart';

class PaymentRepository {
  final CollectionReference _paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

  Future<List<Payment>> fetchPayments() async {
    final querySnapshot = await _paymentsCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Payment.fromMap(data);
    }).toList();
  }

  Future<void> addPayment(Payment payment) async {
    await _paymentsCollection.add(payment.toMap());
  }

  Future<void> updatePayment(Payment payment) async {
    await _paymentsCollection.doc(payment.id).update(payment.toMap());
  }

  Future<void> deletePayment(String paymentId) async {
    await _paymentsCollection.doc(paymentId).delete();
  }
}
