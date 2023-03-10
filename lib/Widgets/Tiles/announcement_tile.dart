import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class AnnouncementCard extends ConsumerWidget {
  const AnnouncementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementsProvider);
    return announcements.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (announcement) {
        if (announcement.isEmpty) {
          return const SizedBox();
        } else {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4.0),
              color: ref.watch(backgroundColorProvider),
            ),
            child: ListTile(
              dense: true,
              leading: const Icon(CupertinoIcons.speaker_1),
              title: Text(
                announcement[0].title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  announcement[0].description,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
