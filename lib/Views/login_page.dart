import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/form_validators.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../Providers/loading_providers.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final loading = ref.watch(loadingProvider);
    final emailError = ref.watch(emailErrorProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final loginError = ref.watch(firebaseLoginError);
    final scaffoldKey = AppConstants.scaffoldKey;
    bool isDrawerOpen = scaffoldKey.currentState == null
        ? false
        : scaffoldKey.currentState!.isEndDrawerOpen;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: PlatformUtils.isWeb() ? 0.0 : 22.0,
          horizontal: 22.0,
        ),
        child: SingleChildScrollView(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: 30.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: ResponsiveLayout.isMobileBrowser(context)
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisAlignment: ResponsiveLayout.isMobileBrowser(context)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SheetHeader(
                title: 'Sign In',
                showCloseButton: !isDrawerOpen,
              ),
              Spacing.vertical(5),
              _buildSignInInstructions(context),
              _buildEmailTextField(context, ref, user, emailError),
              _buildPasswordFormField(context, ref, passwordError),
              loginError == null ? Spacing.vertical(10) : Spacing.vertical(0),
              _buildLoginErrorWidget(loginError),
              loginError == null ? Spacing.vertical(0) : Spacing.vertical(20),
              loading == true
                  ? const LargeElevatedLoadingButton()
                  : SizedBox(
                      width: ResponsiveLayout.isMobileBrowser(context)
                          ? double.infinity
                          : AppConstants.formWidthWeb,
                      child: _buildSignInButton(
                        context,
                        ref,
                        email,
                        password,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  _buildSignUpButton(context, ref),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInInstructions(BuildContext context) {
    double fontSize = ResponsiveLayout.isMobileBrowser(context) ? 12 : 14;
    return SizedBox(
      width: ResponsiveLayout.isMobileBrowser(context)
          ? double.infinity
          : AppConstants.formWidthWeb,
      child: Column(
        crossAxisAlignment: ResponsiveLayout.isMobileBrowser(context)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.vertical(15),
          Text(
            'Sign in to collect and redeem points, access your member code, save favorites and more.',
            style: TextStyle(fontSize: fontSize),
            textAlign: ResponsiveLayout.isMobileBrowser(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          Spacing.vertical(10),
          Text(
            'If you belong to our legacy points or membership program, or you had an account of any kind on our legacy website, you must create a new account.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            textAlign: ResponsiveLayout.isMobileBrowser(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          Spacing.vertical(25),
        ],
      ),
    );
  }

  Widget _buildEmailTextField(
      BuildContext context, WidgetRef ref, UserModel user, String? emailError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).email(user: user, autofocus: true),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(emailError ?? ''),
        ),
      ],
    );
  }

  Widget _buildPasswordFormField(
      BuildContext context, WidgetRef ref, String? passwordError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            SizedBox(
              width: ResponsiveLayout.isMobileBrowser(context)
                  ? double.infinity
                  : AppConstants.formWidthWeb,
              child: JusTextField(ref: ref).password(),
            ),
            Positioned(
              right: 10, // Adjust this value as needed for proper alignment
              child: _forgotPasswordButton(context, ref),
            ),
          ],
        ),
        JusTextField(ref: ref).error(passwordError ?? ''),
      ],
    );
  }

  Widget _forgotPasswordButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text('Forgot?'),
      onPressed: () {
        ref.read(emailErrorProvider.notifier).state = null;
        ref.read(firebaseLoginError.notifier).state = null;
        Navigator.of(context).pop();
        NavigationHelpers.navigateToForgotPasswordPage(context, ref);
      },
    );
  }

  Widget _buildSignInButton(
      BuildContext context, WidgetRef ref, String email, String password) {
    return LargeElevatedButton(
      buttonText: 'Sign In',
      onPressed: () async {
        ref.read(loadingProvider.notifier).state = true;
        validateForm(ref: ref, email: email, password: password);
        await loginUser(context: context, ref: ref);
        ref.read(loadingProvider.notifier).state = false;
        ref.invalidate(bottomNavigationProvider);
        ref.invalidate(passwordProvider);
        PlatformUtils.isWeb()
            ? NavigationHelpers.popEndDrawer(context)
            : Navigator.pop(context);
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text(
        'Sign up',
        style: TextStyle(
            color: Colors.black, decoration: TextDecoration.underline),
      ),
      onPressed: () {
        ref.read(emailErrorProvider.notifier).state = null;
        ref.read(passwordErrorProvider.notifier).state = null;
        Navigator.pop(context);
        NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
            context, ref, AppConstants.scaffoldKey, const RegisterPage());
      },
    );
  }

  Widget _buildLoginErrorWidget(String? loginError) {
    if (loginError != null) {
      return ShowError(
        error: loginError,
      );
    } else {
      return const SizedBox();
    }
  }

  void validateForm(
      {required WidgetRef ref,
      required String email,
      required String password}) {
    bool isValid = true;

    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
      isValid = false;
    }

    if (password.isEmpty) {
      FormValidator().passwordRegister(ref);
      isValid = false;
    }

    ref.read(loginValidatedProvider.notifier).state = isValid;
  }

  Future<void> loginUser(
      {required BuildContext context, required WidgetRef ref}) async {
    if (ref.read(loginValidatedProvider)) {
      try {
        await AuthServices().loginWithEmailAndPassword(
            email: ref.read(emailProvider),
            password: ref.read(passwordProvider));
      } catch (e) {
        ref.read(loadingProvider.notifier).state = false;
        ref.read(firebaseLoginError.notifier).state = e.toString();
      }
    }
  }
}
