import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';

class JusTextField {
  final WidgetRef ref;

  JusTextField({
    required this.ref,
  });
  email({bool? autofocus}) {
    final email = ref.watch(emailProvider);
    return TextFormField(
      autofocus: autofocus ?? false,
      initialValue: email,
      onChanged: (value) => ref.read(emailProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }

  phone({bool? autofocus}) {
    final phone = ref.watch(phoneProvider);
    return TextFormField(
      initialValue: phone.toString(),
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(phoneProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Phone #',
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
    );
  }

  lastName({bool? autofocus}) {
    final lastName = ref.watch(lastNameProvider);
    return TextFormField(
      initialValue: lastName,
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(lastNameProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Last Name',
      ),
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
    );
  }

  firstName({bool? autofocus}) {
    final firstName = ref.watch(firstNameProvider);
    return TextFormField(
      initialValue: firstName,
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(firstNameProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'First name',
      ),
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
    );
  }

  password({bool? autofocus}) {
    final password = ref.watch(passwordProvider);
    return TextFormField(
      initialValue: password,
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(passwordProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      obscureText: true,
    );
  }

  confirmPassword({bool? autofocus}) {
    return TextFormField(
      initialValue: null,
      autofocus: autofocus ?? false,
      onChanged: (value) =>
          ref.read(confirmPasswordProvider.notifier).state = value,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Confirm Password',
      ),
    );
  }

  error(String? error) {
    if (error == null) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ShowError(
          error: error,
        ),
      );
    }
  }
}
