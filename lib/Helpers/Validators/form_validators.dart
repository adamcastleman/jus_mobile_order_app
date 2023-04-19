import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';

class FormValidator {
  email(WidgetRef ref) {
    ref.read(emailErrorProvider.notifier).state =
        'This email address is badly formatted or otherwise invalid.';
    ref.read(loadingProvider.notifier).state = false;
  }

  passwordRegister(WidgetRef ref) {
    ref.read(passwordErrorProvider.notifier).state =
        'This password is not valid. Please attempt a new one.';
    ref.read(loadingProvider.notifier).state = false;
  }

  confirmPassword(WidgetRef ref) {
    ref.read(confirmPasswordErrorProvider.notifier).state =
        'Passwords do not match';
    ref.read(loadingProvider.notifier).state = false;
  }

  firstName(WidgetRef ref) {
    ref.read(firstNameErrorProvider.notifier).state =
        'Please provide your first name';
    ref.read(loadingProvider.notifier).state = false;
  }

  lastName(WidgetRef ref) {
    ref.read(lastNameErrorProvider.notifier).state =
        'Please provide your last name';
    ref.read(loadingProvider.notifier).state = false;
  }

  phone(WidgetRef ref) {
    ref.read(phoneErrorProvider.notifier).state =
        'Phone number must be exactly 10 digits';
    ref.read(loadingProvider.notifier).state = false;
  }
}
