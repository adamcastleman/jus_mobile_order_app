import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class InvalidPaymentSheet extends StatelessWidget {
  final String error;
  const InvalidPaymentSheet({required this.error, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      height: MediaQuery.of(context).size.height * 0.33,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Whoops...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              error,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
            ),
            Center(
              child: LargeElevatedButton(
                buttonText: 'Close',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
