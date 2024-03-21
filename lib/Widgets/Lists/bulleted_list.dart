import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';

class BulletedList extends StatelessWidget {
  final String title;
  final List<String> items;
  final double titleFontSize;
  final double bulletFontSize;

  const BulletedList({
    required this.title,
    required this.items,
    required this.titleFontSize,
    required this.bulletFontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            title,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize),
            maxLines: 1,
          ),
          Spacing.vertical(10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '• ',
                    style: TextStyle(fontSize: bulletFontSize),
                    maxLines: 1,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      item,
                      style: TextStyle(fontSize: bulletFontSize),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
