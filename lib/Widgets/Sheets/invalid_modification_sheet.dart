import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class InvalidModificationSheet extends StatelessWidget {
  final String category;
  const InvalidModificationSheet({required this.category, super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Whoops...',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'You must include at least one $category.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            LargeElevatedButton(
                buttonText: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
