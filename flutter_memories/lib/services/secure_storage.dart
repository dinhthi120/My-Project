import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

class PinSecureStorage {
  static const _pinNumber = 'pin';

  // Set Pin number to secure storage
  static Future setPinNumber(String pinNumber) async =>
      await _storage.write(key: _pinNumber, value: pinNumber);

  // Read Pin number from secure storage
  static Future<String?> getPinNumber() async =>
      await _storage.read(key: _pinNumber);

  // Delete Pin number from secure storage
  static deletePinNumber() async => await _storage.delete(key: _pinNumber);
}

class QuestionSecureStorage {
  static const _securityQuestion = 'question';

  // Set security Quesion to secure storage
  static Future setSecurityQuestion(String question) async =>
      await _storage.write(key: _securityQuestion, value: question);

  // Read security Question from secure storage
  static Future<String?> getSecurityQuestion() async =>
      await _storage.read(key: _securityQuestion);

  // Delete security Question from secure storage
  static deleteSecurityQuestion() async =>
      await _storage.delete(key: _securityQuestion);
}

class AnswerSecureStorage {
  static const _securityAnswer = 'answer';

  // Set security Answer to secure storage
  static Future setSecurityAnswer(String answer) async =>
      await _storage.write(key: _securityAnswer, value: answer);

  // Read security Answer from secure storage
  static Future<String?> getSecurityAnswer() async =>
      await _storage.read(key: _securityAnswer);

  // Delete security Answer from secure storage
  static deleteSecurityAnswer() async =>
      await _storage.delete(key: _securityAnswer);
}

class CheckUserSession {
  static const _userSession = 'userSession';

  // Set user Session to secure storage
  static Future setUserSession(String userSession) async =>
      await _storage.write(key: _userSession, value: userSession);

  // Read user Session from secure storage
  static Future<String?> getUserSession() async =>
      await _storage.read(key: _userSession);

  // Delete user Session from secure storage
  static deleteUserSession() async => await _storage.delete(key: _userSession);
}

class SelectedTime {
  static const _time = 'selectedTime';

  // Set time to secure storage
  static Future setTime(String time) async =>
      await _storage.write(key: _time, value: time);

  // Read time from secure storage
  static Future<String?> getTime() async => await _storage.read(key: _time);

  // Delete time from secure storage
  static deleteTime() async => await _storage.delete(key: _time);
}

class SelectedLanguage {
  static const _language = 'selectedLanguage';

  // Set Language to secure storage
  static Future setLanguage(String language) async =>
      await _storage.write(key: _language, value: language);

  // Read Language from secure storage
  static Future<String?> getLanguage() async =>
      await _storage.read(key: _language);

  // Delete Language from secure storage
  static deleteLanguage() async => await _storage.delete(key: _language);
}

class CheckScheduledNotification {
  static const _checkNotificationActivate = 'check';

  // Set time to secure storage
  static Future setCheckNotificationActivate(
          String checkNotificationActivate) async =>
      await _storage.write(
          key: _checkNotificationActivate, value: checkNotificationActivate);

  // Read CheckNotificationActivate from secure storage
  static Future<String?> getCheckNotificationActivate() async =>
      await _storage.read(key: _checkNotificationActivate);

  // Delete CheckNotificationActivate from secure storage
  static deleteCheckNotificationActivate() async =>
      await _storage.delete(key: _checkNotificationActivate);
}

class CheckGoogleUserEmail {
  static const _checkGoogleUserEmail = 'userEmail';

  // Set time to secure storage
  static Future setUserEmail(String checkUserEmail) async =>
      await _storage.write(key: _checkGoogleUserEmail, value: checkUserEmail);

  // Read CheckUserEmail from secure storage
  static Future<String?> getUserEmail() async =>
      await _storage.read(key: _checkGoogleUserEmail);

  // Delete CheckUserEmail from secure storage
  static deleteUserEmail() async =>
      await _storage.delete(key: _checkGoogleUserEmail);
}

class CheckGoogleUserAvatar {
  static const _checkGoogleUserAvatar = 'userAvatar';

  // Set time to secure storage
  static Future setUserAvatar(String userAvatar) async =>
      await _storage.write(key: _checkGoogleUserAvatar, value: userAvatar);

  // Read UserAvatar from secure storage
  static Future<String?> getUserAvatar() async =>
      await _storage.read(key: _checkGoogleUserAvatar);

  // Delete UserAvatar from secure storage
  static deleteUserAvatar() async =>
      await _storage.delete(key: _checkGoogleUserAvatar);
}
