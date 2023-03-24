import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/announcements_provider_widget.dart';

class AnnouncementTile extends ConsumerWidget {
  const AnnouncementTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnouncementsProviderWidget(
      builder: (announcements) {
        if (announcements.isEmpty) {
          return const SizedBox();
        } else {
          return Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.white,
            ),
            child: ListTile(
              dense: true,
              title: Text(
                announcements.first.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  announcements.first.description,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
