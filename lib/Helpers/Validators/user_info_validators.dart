import 'package:email_validator/email_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/form_validators.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/toast.dart';

class UserInfoValidators {
  final WidgetRef ref;

  UserInfoValidators({required this.ref});
  validateUserData(
    UserModel user,
  ) async {
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final phone = ref.watch(phoneProvider);
    final email = ref.watch(emailProvider);
    final firstNameErrorNotifier = ref.read(firstNameErrorProvider.notifier);
    final lastNameErrorNotifier = ref.read(lastNameErrorProvider.notifier);
    final phoneErrorNotifier = ref.read(phoneErrorProvider.notifier);
    final emailErrorNotifier = ref.read(emailErrorProvider.notifier);
    final formValidatedNotifier = ref.read(formValidatedProvider.notifier);

    if (firstName.isEmpty) {
      FormValidator().firstName(ref);
    } else {
      firstNameErrorNotifier.state = null;
    }

    if (lastName.isEmpty) {
      FormValidator().lastName(ref);
    } else {
      lastNameErrorNotifier.state = null;
    }

    if (phone.length != 10) {
      FormValidator().phone(ref);
    } else {
      phoneErrorNotifier.state = null;
    }
    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
    } else {
      emailErrorNotifier.state = null;
    }

    if (firstNameErrorNotifier.state == null &&
        lastNameErrorNotifier.state == null &&
        phoneErrorNotifier.state == null &&
        emailErrorNotifier.state == null) {
      formValidatedNotifier.state = true;
    }
  }
}

class PasswordValidators {
  final WidgetRef ref;

  PasswordValidators({required this.ref});

  bool validateEmptyPassword() {
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);

    if (password.isEmpty && confirmPassword.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePassword() {
    final password = ref.watch(passwordProvider);
    final passwordErrorNotifier = ref.watch(passwordErrorProvider.notifier);
    if (password.length < 6) {
      passwordErrorNotifier.state =
          'Password must be at least 6 characters long.';
      return false;
    } else {
      passwordErrorNotifier.state = null;
      return true;
    }
  }

  bool validateConfirmPassword() {
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);

    if (password.isEmpty && confirmPassword.isEmpty) {
      return true; // both fields are empty, so consider it valid
    }

    if (password != confirmPassword) {
      ref.read(confirmPasswordErrorProvider.notifier).state =
          'Passwords do not match';
      return false;
    } else {
      ref.read(confirmPasswordErrorProvider.notifier).state = null;
      return true;
    }
  }
}

class AccountInfoUpdater {
  final WidgetRef ref;
  final UserModel user;

  AccountInfoUpdater({
    required this.ref,
    required this.user,
  });

  Future<void> update() async {
    ref.read(loadingProvider.notifier).state = true;

    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);

    bool formValidated = true;
    bool passwordUpdated = false;

    if (password.isNotEmpty || confirmPassword.isNotEmpty) {
      final passwordValidators = PasswordValidators(ref: ref);

      if (passwordValidators.validatePassword() &&
          passwordValidators.validateConfirmPassword()) {
        await _updatePassword(ref, user);
        passwordUpdated = true;
      } else {
        formValidated = false;
      }
    }

    UserInfoValidators(ref: ref).validateUserData(user);

    if (!ref.read(formValidatedProvider.notifier).state) {
      formValidated = false;
    }

    if (formValidated) {
      if (!passwordUpdated) {
        await _updateUser(ref, user);
      }

      ToastHelper.showToast(message: 'Account info updated');
    }

    ref.read(loadingProvider.notifier).state = false;
  }

  _updatePassword(WidgetRef ref, UserModel user) async {
    try {
      await AuthServices().updatePassword(ref.watch(passwordProvider));
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      ref.read(passwordProvider.notifier).state = '';
      ref.read(confirmPasswordProvider.notifier).state = '';
      ref.read(firebaseErrorProvider.notifier).state = e.toString();
    }
  }

  _updateUser(
    WidgetRef ref,
    UserModel user,
  ) async {
    if (ref.read(formValidatedProvider.notifier).state == true) {
      try {
        await UserServices(uid: user.uid).updateUser(
          firstName: ref.read(firstNameProvider),
          lastName: ref.read(lastNameProvider),
          phone: ref.read(phoneProvider),
          email: ref.read(emailProvider),
        );
      } catch (e) {
        ref.read(loadingProvider.notifier).state = false;
        ref.read(firebaseErrorProvider.notifier).state = e.toString();
      }
    } else {}
  }
}
