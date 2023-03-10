import 'package:hooks_riverpod/hooks_riverpod.dart';

final emailProvider = StateProvider.autoDispose<String>((ref) => '');

final passwordProvider = StateProvider<String>((ref) => '');

final confirmPasswordProvider = StateProvider<String>((ref) => '');

final firstNameProvider = StateProvider<String>((ref) => '');

final lastNameProvider = StateProvider<String>((ref) => '');

final phoneProvider = StateProvider<String>((ref) => '');

final emailErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final passwordErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final confirmPasswordErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final firstNameErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final lastNameErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final phoneErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final loginValidatedProvider = StateProvider.autoDispose<bool>((ref) => false);

final formValidatedProvider = StateProvider.autoDispose<bool>((ref) => false);

final changePasswordValidatedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final firebaseLoginError = StateProvider.autoDispose<String?>((ref) => null);

final firebaseErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final forgotPasswordValidationProvider =
    StateProvider.autoDispose<bool>((ref) => false);
