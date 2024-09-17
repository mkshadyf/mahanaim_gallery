import 'package:flutter/foundation.dart';
import '../models/payment.dart';
import '../repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository = PaymentRepository();
  List<Payment> _payments = [];
  bool _isLoading = false;

  List<Payment> get payments => _payments;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  Future<void> loadPayments() async {
    _isLoading = true;
    _error = null; // Reset error on new load
    notifyListeners();
    try {
      _payments = await _paymentRepository.fetchPayments();
    } catch (e) {
      print('Error loading payments: $e');
      _error = 'Failed to load payments'; // Set error message
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPayment(Payment payment) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _paymentRepository.addPayment(payment);
      await loadPayments();
    } catch (e) {
      print('Error adding payment: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePayment(Payment payment) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _paymentRepository.updatePayment(payment);
      await loadPayments();
    } catch (e) {
      print('Error updating payment: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deletePayment(String paymentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _paymentRepository.deletePayment(paymentId);
      await loadPayments();
    } catch (e) {
      print('Error deleting payment: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
