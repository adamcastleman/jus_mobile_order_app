import 'package:hooks_riverpod/hooks_riverpod.dart';

final emailProvider = StateProvider<String>((ref) => '');

final passwordProvider = StateProvider<String>((ref) => '');

final confirmPasswordProvider = StateProvider<String>((ref) => '');

final firstNameProvider = StateProvider<String>((ref) => '');

final lastNameProvider = StateProvider<String>((ref) => '');

final phoneProvider = StateProvider<String>((ref) => '');

final addressLine1Provider = StateProvider<String>((ref) => '');

final addressLine2Provider = StateProvider<String>((ref) => '');

final cityProvider = StateProvider<String>((ref) => '');

final usStateNameProvider = StateProvider<String>((ref) => '');

final zipCodeProvider = StateProvider<String>((ref) => '');

final emailErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final passwordErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final confirmPasswordErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final firstNameErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final lastNameErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final phoneErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final addressLine1ErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final addressLine2ErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final cityErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final stateNameErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final zipCodeErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final loginValidatedProvider = StateProvider.autoDispose<bool>((ref) => false);

final formValidatedProvider = StateProvider.autoDispose<bool>((ref) => false);

final changePasswordValidatedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final firebaseLoginError = StateProvider.autoDispose<String?>((ref) => null);

final firebaseErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

final forgotPasswordValidationProvider =
    StateProvider.autoDispose<bool>((ref) => false);
