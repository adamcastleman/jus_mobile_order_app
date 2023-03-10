import 'package:encrypt/encrypt.dart' as encrypt;

class Encryptor {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encryptor = encrypt.Encrypter(
    encrypt.AES(key),
  );

  static encryptText(String text) {
    return encryptor.encrypt(text, iv: iv);
  }

  static decryptText(text) {
    return encryptor.decrypt64(text, iv: iv);
  }
}
