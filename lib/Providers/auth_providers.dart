import 'package:hooks_riverpod/hooks_riverpod.dart';

final emailProvider = StateProvider.autoDispose<String>((ref) => '');

final passwordProvider = StateProvider.autoDispose<String>((ref) => '');

final confirmPasswordProvider = StateProvider.autoDispose<String>((ref) => '');

final firstNameProvider = StateProvider.autoDispose<String>((ref) => '');

final lastNameProvider = StateProvider.autoDispose<String>((ref) => '');

final phoneProvider = StateProvider.autoDispose<String>((ref) => '');

final emailErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final passwordErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final confirmPasswordErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final firstNameErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final lastNameErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final phoneErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final loginValidatedProvider = StateProvider.autoDispose<bool>((ref) => false);

final registrationValidatedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final firebaseLoginError = StateProvider.autoDispose<String?>((ref) => null);

final firebaseRegistrationError =
    StateProvider.autoDispose<String?>((ref) => null);

final authLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final forgotPasswordValidationProvider =
    StateProvider.autoDispose<bool>((ref) => false);
