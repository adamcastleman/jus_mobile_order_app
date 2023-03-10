import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';

class EmptyLocationTile extends StatelessWidget {
  const EmptyLocationTile({super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      contentPadding: const EdgeInsets.all(15.0),
      title: Text(
        'No nearby stores',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'It looks like we don\'t currently have any stores within this area. Or, we can\'t display them right now.',
              style: TextStyle(fontSize: 14),
            ),
            Spacing().vertical(10),
            const Text(
              //TODO decide if we should store store request locations
              'Let us know if you\'d like to see a store in this area.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
