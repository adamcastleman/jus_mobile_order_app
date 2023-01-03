import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';

class Validator {
  email(WidgetRef ref) {
    ref.read(emailErrorProvider.notifier).state =
        'This email address is badly formatted or otherwise invalid.';
    ref.read(authLoadingProvider.notifier).state = false;
  }

  password(WidgetRef ref) {
    ref.read(passwordErrorProvider.notifier).state = 'Password cannot be empty';
    ref.read(authLoadingProvider.notifier).state = false;
  }

  confirmPassword(WidgetRef ref) {
    ref.read(confirmPasswordErrorProvider.notifier).state =
        'Passwords do not match';
    ref.read(authLoadingProvider.notifier).state = false;
  }

  firstName(WidgetRef ref) {
    ref.read(firstNameErrorProvider.notifier).state =
        'Please provide your first name';
    ref.read(authLoadingProvider.notifier).state = false;
  }

  lastName(WidgetRef ref) {
    ref.read(lastNameErrorProvider.notifier).state =
        'Please provide your last name';
    ref.read(authLoadingProvider.notifier).state = false;
  }

  phone(WidgetRef ref) {
    ref.read(phoneErrorProvider.notifier).state =
        'Phone number must be exactly 10 digits';
    ref.read(authLoadingProvider.notifier).state = false;
  }
}
