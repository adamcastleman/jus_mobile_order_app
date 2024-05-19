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
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);
    final email = ref.watch(emailProvider);
    final emailError = ref.watch(emailErrorProvider);
    final loading = ref.watch(loadingProvider);
    final firebaseError = ref.watch(firebaseLoginError);
    final scaffoldKey = AppConstants.scaffoldKey;
    bool isDrawerOpen = scaffoldKey.currentState == null
        ? false
        : scaffoldKey.currentState!.isEndDrawerOpen;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22.0,
          ),
          child: SingleChildScrollView(
            primary: false,
            physics: const ClampingScrollPhysics(),
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
                  title: 'Reset password',
                  showCloseButton: !isDrawerOpen,
                ),
                _buildForgotPasswordInstructions(context),
                Spacing.vertical(25),
                _buildEmailTextField(context, ref, user, emailError),
                firebaseError == null
                    ? Spacing.vertical(30)
                    : Spacing.vertical(20),
                firebaseError != null
                    ? ShowError(
                        error: firebaseError,
                      )
                    : const SizedBox(),
                firebaseError == null
                    ? Spacing.vertical(0)
                    : Spacing.vertical(20),
                loading == true
                    ? const LargeElevatedLoadingButton()
                    : SizedBox(
                        width: ResponsiveLayout.isMobileBrowser(context)
                            ? double.infinity
                            : AppConstants.formWidthWeb,
                        child: _buildResetPasswordButton(context, ref, email),
                      ),
                Spacing.vertical(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Remember your password?'),
                    _buildReturnToLoginButton(context, ref),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: ResponsiveLayout.isMobileBrowser(context)
          ? double.infinity
          : AppConstants.formWidthWeb,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reset Password',
            style: ResponsiveLayout.isMobileBrowser(context)
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium,
          ),
          const JusCloseButton(removePadding: true),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordInstructions(BuildContext context) {
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
          const Text(
            'Enter your email and we will send you a link to reset your password.',
          ),
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

  Widget _buildResetPasswordButton(
      BuildContext context, WidgetRef ref, String email) {
    return LargeElevatedButton(
      buttonText: 'Reset Password',
      onPressed: () {
        ref.read(loadingProvider.notifier).state = true;
        validateForm(ref: ref, email: email);
        sendForgotPasswordLink(context: context, ref: ref);
        ref.read(loadingProvider.notifier).state = false;
      },
    );
  }

  Widget _buildReturnToLoginButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text('Go Back'),
      onPressed: () {
        ref.read(emailErrorProvider.notifier).state = null;
        ref.read(firebaseLoginError.notifier).state = null;
        Navigator.of(context).pop();
        NavigationHelpers.navigateToLoginPage(context, ref);
      },
    );
  }

  validateForm({
    required WidgetRef ref,
    required String email,
  }) {
    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
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
        PlatformUtils.isWeb()
            ? NavigationHelpers.popEndDrawer(context)
            : navigator.pop();
      } catch (e) {
        ref.read(loadingProvider.notifier).state = false;
        ref.read(firebaseLoginError.notifier).state = e.toString();
      }
    }
  }
}
