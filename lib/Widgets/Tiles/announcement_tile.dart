import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/announcements_model.dart';

class AnnouncementTile extends ConsumerWidget {
  final List<AnnouncementsModel> announcements;
  const AnnouncementTile({required this.announcements, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: ListTile(
        dense: true,
        title: Text(
          announcements.first.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Text(
            announcements.first.description,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
