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
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';

import 'login_page.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final emailError = ref.watch(emailErrorProvider);
    final loading = ref.watch(loadingProvider);
    final firebaseError = ref.watch(firebaseLoginError);
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
                      'Forgot Password',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Spacing().vertical(15),
                    const Text(
                      'Enter your email and we will send you a link to reset your password.',
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
                    firebaseError == null
                        ? Spacing().vertical(30)
                        : Spacing().vertical(20),
                    firebaseError != null
                        ? ShowError(
                            error: firebaseError,
                          )
                        : const SizedBox(),
                    firebaseError == null
                        ? Spacing().vertical(0)
                        : Spacing().vertical(20),
                    loading == true
                        ? const LargeElevatedLoadingButton()
                        : LargeElevatedButton(
                            buttonText: 'Reset Password',
                            onPressed: () {
                              ref.read(loadingProvider.notifier).state = true;
                              validateForm(ref: ref, email: email);
                              sendForgotPasswordLink(
                                  context: context, ref: ref);
                            },
                          ),
                    Spacing().vertical(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Remember your password?'),
                        TextButton(
                          child: const Text('Go Back'),
                          onPressed: () {
                            ref.read(emailErrorProvider.notifier).state = null;
                            ref.read(firebaseLoginError.notifier).state = null;
                            Navigator.pop(context);
                            ModalBottomSheet().partScreen(
                              enableDrag: true,
                              isScrollControlled: true,
                              isDismissible: true,
                              context: context,
                              builder: (context) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
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
          ],
        ),
      ),
    );
  }

  validateForm({
    required WidgetRef ref,
    required String email,
  }) {
    if (!EmailValidator.validate(email)) {
      Validator().email(ref);
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }
    if (ref.read(emailErrorProvider.notifier).state == null) {
      ref.read(forgotPasswordValidationProvider.notifier).state = true;
    }
  }

  sendForgotPasswordLink(
      {required BuildContext context, required WidgetRef ref}) async {
    if (ref.read(forgotPasswordValidationProvider.notifier).state == true) {
      try {
        final navigator = Navigator.of(context);
        await AuthServices().forgotPassword(email: ref.read(emailProvider));
        navigator.pop();
      } catch (e) {
        ref.read(loadingProvider.notifier).state = false;
        ref.read(firebaseLoginError.notifier).state = e.toString();
      }
    }
  }
}
