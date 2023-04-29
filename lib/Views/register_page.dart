import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/registration_validators.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Views/login_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';

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
                const Align(
                  alignment: Alignment.topRight,
                  child: JusCloseButton(
                    removePadding: true,
                  ),
                ),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacing().vertical(15),
                const Text(
                  'Join now to collect points to redeem for free items, save '
                  'favorite items, and more.',
                ),
                Spacing().vertical(5),
                const Text(
                  'To transfer points from our legacy program, register with '
                  'the same phone number. You can update it later if needed.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacing().vertical(25),
                JusTextField(ref: ref).firstName(),
                JusTextField(ref: ref).error(firstNameError),
                Spacing().vertical(15),
                JusTextField(ref: ref).lastName(),
                JusTextField(ref: ref).error(lastNameError),
                Spacing().vertical(15),
                JusTextField(ref: ref).phone(),
                JusTextField(ref: ref).error(phoneError),
                Spacing().vertical(15),
                JusTextField(ref: ref).email(),
                JusTextField(ref: ref).error(emailError),
                Spacing().vertical(15),
                JusTextField(ref: ref).password(),
                JusTextField(ref: ref).error(passwordError),
                Spacing().vertical(15),
                JusTextField(ref: ref).confirmPassword(),
                JusTextField(ref: ref).error(confirmPasswordError),
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
                          RegistrationValidators(ref: ref).validateForm(
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
                        ModalBottomSheet().fullScreen(
                          context: context,
                          builder: (context) => const LoginPage(),
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
        await AuthServices().registerWithEmailAndPassword(
            email: ref.read(emailProvider),
            password: ref.read(passwordProvider),
            firstName: ref.read(firstNameProvider),
            lastName: ref.read(lastNameProvider),
            phone: ref.read(phoneProvider));
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pop(context);
          ref.read(loadingProvider.notifier).state = false;
        });
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
