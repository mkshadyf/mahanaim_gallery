import '../models/payment.dart';
import '../repositories/payment_repository.dart';

class PaymentService {
  final PaymentRepository _paymentRepository = PaymentRepository();

  Future<List<Payment>> fetchPayments() async {
    return await _paymentRepository.fetchPayments();
  }

  Future<void> addPayment(Payment payment) async {
    await _paymentRepository.addPayment(payment);
  }

  Future<void> updatePayment(Payment payment) async {
    await _paymentRepository.updatePayment(payment);
  }

  Future<void> deletePayment(String paymentId) async {
    await _paymentRepository.deletePayment(paymentId);
  }
}
