bool isValidPhoneNumber(String phone) {
  final RegExp phoneRegex = RegExp(r'^0\d{9}$');
  return phoneRegex.hasMatch(phone);
}
