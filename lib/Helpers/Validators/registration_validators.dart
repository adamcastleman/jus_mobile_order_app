import 'package:email_validator/email_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/form_validators.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';

class RegistrationValidators {
  final WidgetRef ref;

  RegistrationValidators({required this.ref});

  validateForm({
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
    required String confirmPassword,
  }) {
    if (firstName.isEmpty) {
      FormValidator().firstName(ref);
    } else {
      ref.read(firstNameErrorProvider.notifier).state = null;
    }
    if (lastName.isEmpty) {
      FormValidator().lastName(ref);
    } else {
      ref.read(lastNameErrorProvider.notifier).state = null;
    }

    if (phone.length != 10) {
      FormValidator().phone(ref);
    } else {
      ref.read(phoneErrorProvider.notifier).state = null;
    }
    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }
    if (password.isEmpty) {
      FormValidator().passwordRegister(ref);
    } else {
      ref.read(passwordErrorProvider.notifier).state = null;
    }
    if (password != confirmPassword) {
      FormValidator().confirmPassword(ref);
    } else {
      ref.read(confirmPasswordErrorProvider.notifier).state = null;
    }

    if (ref.read(emailErrorProvider.notifier).state == null &&
        ref.read(passwordErrorProvider.notifier).state == null &&
        ref.read(confirmPasswordErrorProvider.notifier).state == null &&
        ref.read(firstNameErrorProvider.notifier).state == null &&
        ref.read(lastNameErrorProvider.notifier).state == null &&
        ref.read(phoneErrorProvider.notifier).state == null) {
      ref.read(formValidatedProvider.notifier).state = true;
    }
  }
}
