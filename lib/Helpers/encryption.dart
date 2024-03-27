import 'package:cloud_functions/cloud_functions.dart';

class Encryption {
  Future<String> encryptText(String plaintext) async {

    try {
     var result = await FirebaseFunctions.instance.httpsCallable('encryptText').call({
        'plaintext': plaintext,
      });
     return result.data;
    } catch (e) {
       throw e.toString();
    }
  }

  Future<String> decryptText(String encryptedText) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('decryptText');
      final result = await callable.call({'encryptedText': encryptedText});
      return result.data;
    } catch(e) {
      throw e.toString();
    }
  }


}
