import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: TextButton(
        child: const Text('Sign Out'),
        onPressed: () {
          AuthServices().signOut();
        },
      ),
    );
  }
}
