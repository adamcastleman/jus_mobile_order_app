import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';

class ScanDescriptorWidget extends StatelessWidget {
  final bool isScanAndPay;
  final bool isActiveMember;

  const ScanDescriptorWidget({
    super.key,
    required this.isScanAndPay,
    required this.isActiveMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isScanAndPay ? 'Earn points and pay' : 'Scan to earn points',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.vertical(5),
        Text(
          _displayDescriptorText(),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  String _displayDescriptorText() {
    if (isScanAndPay) {
      if (isActiveMember) {
        return 'Check-in to Membership, earn points, and pay.';
      } else {
        return '';
      }
    } else {
      if (isActiveMember) {
        return 'Check-in to Membership and earn points.';
      } else {
        return 'Scan before paying.';
      }
    }
  }
}
