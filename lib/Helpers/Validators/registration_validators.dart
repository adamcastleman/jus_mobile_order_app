import 'package:email_validator/email_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/form_validators.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';

class RegistrationValidators {
  final WidgetRef ref;

  RegistrationValidators({required this.ref});

  bool validateForm({
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
    required String confirmPassword,
  }) {
    bool isValid = true; // Assume the form is valid initially

    if (firstName.isEmpty) {
      FormValidator().firstName(ref);
      isValid = false; // Set to false if any validation fails
    } else {
      ref.read(firstNameErrorProvider.notifier).state = null;
    }
    if (lastName.isEmpty) {
      FormValidator().lastName(ref);
      isValid = false;
    } else {
      ref.read(lastNameErrorProvider.notifier).state = null;
    }

    if (phone.length != 10) {
      FormValidator().phone(ref);
      isValid = false;
    } else {
      ref.read(phoneErrorProvider.notifier).state = null;
    }
    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
      isValid = false;
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }
    if (password.isEmpty) {
      FormValidator().passwordRegister(ref);
      isValid = false;
    } else {
      ref.read(passwordErrorProvider.notifier).state = null;
    }
    if (password != confirmPassword) {
      FormValidator().confirmPassword(ref);
      isValid = false;
    } else {
      ref.read(confirmPasswordErrorProvider.notifier).state = null;
    }

    return isValid; // Return the overall validity of the form
  }
}
