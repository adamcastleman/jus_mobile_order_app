import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';

class MembershipTermsOfServiceButton extends StatelessWidget {
  const MembershipTermsOfServiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Text(
        'Membership Terms of Service',
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
        NavigationHelpers.navigateToMembershipTermsOfService(context);
      },
    );
  }
}
