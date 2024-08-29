class NotificationSettings {
  final bool inApp;
  final bool sms;
  final bool email;
  final String phoneNumber;

  const NotificationSettings({
    this.inApp = true,
    this.sms = false,
    this.email = false,
    this.phoneNumber = '',
  });
}
