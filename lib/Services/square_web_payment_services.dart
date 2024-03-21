import 'package:js/js.dart';

@JS('squareCreditCardWebForm') // JavaScript function binding
external void invokeSquareCreditCardWebForm(
    String applicationId, String locationId, Function callback);

@JS('squareGiftCardWebForm') // JavaScript function binding
external void invokeSquareGiftCardWebForm(
    String applicationId, String locationId, Function callback);

@JS('setTokenizationCallback')
external void setSquareTokenizationCallback(Function callback);

// square_payment_interface.dart
abstract class SquarePaymentInterface {
  void squareCreditCardWebForm(
      String applicationId, String locationId, Function(String) callback);

  void squareGiftCardWebForm(
      String applicationId, String locationId, Function(String) callback);

  void setTokenizationCallback(Function callback);
}

class SquarePaymentWebServices extends SquarePaymentInterface {
  @override
  void squareCreditCardWebForm(
      String applicationId, String locationId, Function(String) callback) {
    invokeSquareCreditCardWebForm(
      applicationId,
      locationId,
      allowInterop(callback),
    ); // Calls the external JS function
  }

  @override
  void squareGiftCardWebForm(
      String applicationId, String locationId, Function(String) callback) {
    invokeSquareGiftCardWebForm(
      applicationId,
      locationId,
      allowInterop(callback),
    ); // Calls the external JS function
  }

  @override
  void setTokenizationCallback(Function callback) {
    setSquareTokenizationCallback(
      allowInterop(callback),
    ); // Call the JavaScript-bound function
  }
}
