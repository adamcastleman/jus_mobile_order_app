import 'package:email_validator/email_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/form_validators.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';

class CheckoutValidators {
  final WidgetRef ref;
  CheckoutValidators({required this.ref});

  void validateForm() {
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final email = ref.watch(emailProvider);
    final phone = ref.watch(phoneProvider);

    _validateFirstName(ref, firstName);
    _validateLastName(ref, lastName);
    _validatePhone(ref, phone);
    _validateEmail(ref, email);

    if (_isFormValid(ref)) {
      ref.read(formValidatedProvider.notifier).state = true;
    }
  }

  void _validateFirstName(WidgetRef ref, String firstName) {
    if (firstName.isEmpty) {
      FormValidator().firstName(ref);
    } else {
      ref.read(firstNameErrorProvider.notifier).state = null;
    }
  }

  void _validateLastName(WidgetRef ref, String lastName) {
    if (lastName.isEmpty) {
      FormValidator().lastName(ref);
    } else {
      ref.read(lastNameErrorProvider.notifier).state = null;
    }
  }

  void _validatePhone(WidgetRef ref, String phone) {
    if (phone.length != 10) {
      FormValidator().phone(ref);
    } else {
      ref.read(phoneErrorProvider.notifier).state = null;
    }
  }

  void _validateEmail(WidgetRef ref, String email) {
    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }
  }

  bool _isFormValid(WidgetRef ref) {
    return ref.read(emailErrorProvider.notifier).state == null &&
        ref.read(firstNameErrorProvider.notifier).state == null &&
        ref.read(lastNameErrorProvider.notifier).state == null &&
        ref.read(phoneErrorProvider.notifier).state == null;
  }
}
