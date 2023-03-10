import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/validators.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Views/login_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final phone = ref.watch(phoneProvider);
    final emailError = ref.watch(emailErrorProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final confirmPasswordError = ref.watch(confirmPasswordErrorProvider);
    final firstNameError = ref.watch(firstNameErrorProvider);
    final lastNameError = ref.watch(lastNameErrorProvider);
    final phoneError = ref.watch(phoneErrorProvider);
    final firebaseError = ref.watch(firebaseErrorProvider);
    final loading = ref.watch(loadingProvider);
    return Container(
      padding: EdgeInsets.only(
        top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .padding
            .top,
      ),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: const Icon(CupertinoIcons.clear_circled),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacing().vertical(30),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacing().vertical(15),
                const Text(
                  'Join now to collect points to redeem for free items, save favorite items, and more.',
                ),
                Spacing().vertical(5),
                const Text(
                  'To transfer your points from our legacy points program, use the same phone number. You can change this later, if necessary.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacing().vertical(25),
                TextFormField(
                  initialValue: firstName,
                  onChanged: (value) =>
                      ref.read(firstNameProvider.notifier).state = value,
                  decoration: const InputDecoration(
                    hintText: 'First name',
                  ),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                ),
                firstNameError == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ShowError(
                          error: firstNameError,
                        ),
                      ),
                Spacing().vertical(15),
                TextFormField(
                  initialValue: lastName,
                  onChanged: (value) =>
                      ref.read(lastNameProvider.notifier).state = value,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                  ),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                ),
                lastNameError == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ShowError(
                          error: lastNameError,
                        ),
                      ),
                Spacing().vertical(15),
                TextFormField(
                  initialValue: phone.toString(),
                  onChanged: (value) =>
                      ref.read(phoneProvider.notifier).state = value,
                  decoration: const InputDecoration(
                    hintText: 'Phone #',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                phoneError == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ShowError(
                          error: phoneError,
                        ),
                      ),
                Spacing().vertical(15),
                TextFormField(
                  initialValue: email,
                  onChanged: (value) =>
                      ref.read(emailProvider.notifier).state = value,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                ),
                emailError == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ShowError(
                          error: emailError,
                        ),
                      ),
                Spacing().vertical(15),
                TextFormField(
                  initialValue: password,
                  onChanged: (value) =>
                      ref.read(passwordProvider.notifier).state = value,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),
                passwordError == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ShowError(
                          error: passwordError,
                        ),
                      ),
                Spacing().vertical(15),
                TextFormField(
                  initialValue: null,
                  onChanged: (value) =>
                      ref.read(confirmPasswordProvider.notifier).state = value,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                ),
                confirmPasswordError == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ShowError(
                          error: confirmPasswordError,
                        ),
                      ),
                firebaseError == null
                    ? Spacing().vertical(40)
                    : Spacing().vertical(20),
                ShowError(error: firebaseError),
                firebaseError == null
                    ? Spacing().vertical(0)
                    : Spacing().vertical(20),
                loading == true
                    ? const LargeElevatedLoadingButton()
                    : LargeElevatedButton(
                        buttonText: 'Sign Up',
                        onPressed: () {
                          ref.read(loadingProvider.notifier).state = true;
                          validateForm(
                            ref: ref,
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            phone: phone,
                            password: password,
                            confirmPassword: confirmPassword,
                          );
                          signUpUser(
                            context: context,
                            ref: ref,
                            email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName,
                            phone: phone,
                          );
                        },
                      ),
                Spacing().vertical(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      child: const Text('Sign In'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        ref.read(emailErrorProvider.notifier).state = null;
                        ref.read(passwordErrorProvider.notifier).state = null;
                        ModalBottomSheet().partScreen(
                          isScrollControlled: true,
                          enableDrag: true,
                          isDismissible: true,
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validateForm({
    required WidgetRef ref,
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
    required String confirmPassword,
  }) async {
    if (firstName.isEmpty) {
      Validator().firstName(ref);
    } else {
      ref.read(firstNameErrorProvider.notifier).state = null;
    }
    if (lastName.isEmpty) {
      Validator().lastName(ref);
    } else {
      ref.read(lastNameErrorProvider.notifier).state = null;
    }

    if (phone.length != 10) {
      Validator().phone(ref);
    } else {
      ref.read(phoneErrorProvider.notifier).state = null;
    }
    if (!EmailValidator.validate(email)) {
      Validator().email(ref);
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }
    if (password.isEmpty) {
      Validator().passwordRegister(ref);
    } else {
      ref.read(passwordErrorProvider.notifier).state = null;
    }
    if (password != confirmPassword) {
      Validator().confirmPassword(ref);
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

  signUpUser({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
    required firstName,
    required lastName,
    required phone,
  }) async {
    if (ref.read(formValidatedProvider.notifier).state == true) {
      try {
        final navigator = Navigator.of(context);
        await AuthServices().registerWithEmailAndPassword(
            email: ref.read(emailProvider),
            password: ref.read(passwordProvider),
            firstName: ref.read(firstNameProvider),
            lastName: ref.read(lastNameProvider),
            phone: ref.read(phoneProvider));
        navigator.pop();
        ref.invalidate(firstNameProvider);
        ref.invalidate(lastNameProvider);
        ref.invalidate(phoneProvider);
        ref.invalidate(passwordProvider);
        ref.invalidate(confirmPasswordProvider);
      } catch (e) {
        ref.read(loadingProvider.notifier).state = false;
        ref.read(firebaseErrorProvider.notifier).state = e.toString();
      }
    } else {}
  }
}
