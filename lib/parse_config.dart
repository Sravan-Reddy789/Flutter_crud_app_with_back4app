/// Back4App / Parse connection settings.
///
/// Replace [applicationId] and [clientKey] after you create the app:
/// Dashboard → App Settings → Security & Keys.
class Back4AppKeys {
  static const applicationId = 'YOUR_APPLICATION_ID';
  static const clientKey = 'YOUR_CLIENT_KEY';
  static const serverUrl = 'https://parseapi.back4app.com';
  static const taskClassName = 'Task';

  static bool get isConfigured =>
      applicationId != 'YOUR_APPLICATION_ID' &&
      applicationId.isNotEmpty &&
      clientKey != 'YOUR_CLIENT_KEY' &&
      clientKey.isNotEmpty;
}
