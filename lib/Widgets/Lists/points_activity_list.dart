import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_activity_provider_widget.dart';

class PointsActivityListView extends StatelessWidget {
  const PointsActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    return PointsActivityProviderWidget(
      builder: (points) => ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemCount: points.length,
        separatorBuilder: (context, index) => JusDivider.thin(),
        itemBuilder: (context, index) {
          bool isPointsEarned = points[index].pointsEarned != 0;
          bool isPointsRedeemed = points[index].pointsRedeemed != 0;
          bool isBoth = isPointsEarned && isPointsRedeemed;
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(points[index].timestamp!);

          return ListTile(
            leading: Icon(
              isBoth
                  ? CupertinoIcons.arrow_merge
                  : isPointsEarned
                      ? CupertinoIcons.add_circled
                      : CupertinoIcons.minus_circle,
              color: isBoth
                  ? Colors.black
                  : isPointsEarned
                      ? Colors.green
                      : Colors.red,
            ),
            title: AutoSizeText(
              isBoth
                  ? 'Earned & Redeemed Points'
                  : isPointsEarned
                      ? 'Earned Points'
                      : 'Redeemed Points',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle:
                Text(DateFormat('M/d/yyyy h:mm a').format(date).toLowerCase()),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: isBoth
                  ? [
                      Text('+${points[index].pointsEarned}'),
                      Text('-${points[index].pointsRedeemed}'),
                    ]
                  : [
                      Text(isPointsEarned
                          ? '+${points[index].pointsEarned}'
                          : '-${points[index].pointsRedeemed}'),
                    ],
            ),
          );
        },
      ),
    );
  }
}
