import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/description_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class PointsDetailPage extends ConsumerWidget {
  const PointsDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(themeColorProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);

    return pointsDetails.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) => Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Spacing().vertical(MediaQuery.of(context).size.height * 0.05),
              Align(
                alignment: Alignment.topLeft,
                child: JusCloseButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  rewardsCard(data),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: data.perks.length,
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        if (index.isEven) {
                          return DescriptionTile(data: data, index: index)
                              .right();
                        } else {
                          return DescriptionTile(data: data, index: index)
                              .left();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  rewardsCard(PointsDetailsModel data) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
      padding: const EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: data.rewardsAmounts.length,
        separatorBuilder: (context, index) => Spacing().vertical(10),
        itemBuilder: (context, index) => rewardsAmountTile(data, index),
      ),
    );
  }

  rewardsAmountTile(PointsDetailsModel data, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: const BorderSide(width: 0.5, color: Colors.grey),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 60,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
            ),
          ),
          child: Center(
            child: AutoSizeText(
              '${data.rewardsAmounts[index]['amount']}',
              style: const TextStyle(fontSize: 22, color: Colors.white),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        title: Text(
          '${data.rewardsAmounts[index]['description']}',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
