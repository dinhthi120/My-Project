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
