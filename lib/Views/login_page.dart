import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Views/forgot_password_page.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/validators.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final loading = ref.watch(authLoadingProvider);
    final emailError = ref.watch(emailErrorProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final loginError = ref.watch(firebaseLoginError);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        primary: false,
        physics: const ClampingScrollPhysics(),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.width * 0.05),
              child: SingleChildScrollView(
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
                    Spacing().vertical(25),
                    Text(
                      'Sign in',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Spacing().vertical(15),
                    const Text(
                      'Sign in to collect and redeem points, access your member code, save favorites and more.',
                    ),
                    Spacing().vertical(25),
                    TextFormField(
                      initialValue: email,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      onChanged: (value) =>
                          ref.read(emailProvider.notifier).state = value,
                      autocorrect: false,
                      autofocus: true,
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
                    Stack(
                      children: [
                        TextFormField(
                          initialValue: password,
                          onChanged: (value) =>
                              ref.read(passwordProvider.notifier).state = value,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: const Text('Forgot?'),
                              onPressed: () {
                                ref.read(emailErrorProvider.notifier).state =
                                    null;
                                ref.read(firebaseLoginError.notifier).state =
                                    null;
                                Navigator.of(context).pop();
                                ModalBottomSheet().partScreen(
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: const ForgotPasswordPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    passwordError == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ShowError(
                              error: passwordError,
                            ),
                          ),
                    loginError == null
                        ? Spacing().vertical(40)
                        : Spacing().vertical(20),
                    loginError != null
                        ? ShowError(
                            error: loginError,
                          )
                        : const SizedBox(),
                    loginError == null
                        ? Spacing().vertical(0)
                        : Spacing().vertical(20),
                    loading == true
                        ? const LargeElevatedLoadingButton()
                        : LargeElevatedButton(
                            buttonText: 'Sign In',
                            onPressed: () {
                              ref.read(authLoadingProvider.notifier).state =
                                  true;
                              validateForm(
                                  ref: ref, email: email, password: password);
                              loginUser(context: context, ref: ref);
                            },
                          ),
                    Spacing().vertical(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          child: const Text('Sign up'),
                          onPressed: () {
                            ref.read(emailErrorProvider.notifier).state = null;
                            ref.read(passwordErrorProvider.notifier).state =
                                null;
                            Navigator.pop(context);
                            ModalBottomSheet().fullScreen(
                              context: context,
                              builder: (context) => const RegisterPage(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  validateForm(
      {required WidgetRef ref,
      required String email,
      required String password}) {
    if (!EmailValidator.validate(email)) {
      Validator().email(ref);
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }
    if (password.isEmpty) {
      Validator().password(ref);
    } else {
      ref.read(passwordErrorProvider.notifier).state = null;
    }
    if (ref.read(emailErrorProvider.notifier).state == null &&
        ref.read(passwordErrorProvider.notifier).state == null) {
      ref.read(loginValidatedProvider.notifier).state = true;
    }
  }
}

loginUser({required BuildContext context, required WidgetRef ref}) async {
  if (ref.read(loginValidatedProvider.notifier).state == true) {
    try {
      final navigator = Navigator.of(context);
      await AuthServices().loginWithEmailAndPassword(
          email: ref.read(emailProvider), password: ref.read(passwordProvider));
      navigator.pop();
    } catch (e) {
      ref.read(authLoadingProvider.notifier).state = false;
      ref.read(firebaseLoginError.notifier).state = e.toString();
    }
  }
}
