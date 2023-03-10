import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/description_tile.dart';

class PointsDetailPage extends ConsumerWidget {
  final bool isScanPage;
  const PointsDetailPage({required this.isScanPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final currentUser = ref.watch(currentUserProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);

    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => pointsDetails.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (points) => Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                isScanPage
                    ? const SizedBox()
                    : Spacing()
                        .vertical(MediaQuery.of(context).size.height * 0.05),
                isScanPage
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.topRight,
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
                      points.name,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    rewardsCard(points, user),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: points.perks.length,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                            thickness: 0.5,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          if (index.isEven) {
                            return DescriptionTile(data: points, index: index)
                                .imageRight();
                          } else {
                            return DescriptionTile(data: points, index: index)
                                .imageLeft();
                          }
                        },
                      ),
                    ),
                    user.uid == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: LargeElevatedButton(
                              buttonText: 'Sign up',
                              onPressed: () {
                                ModalBottomSheet().fullScreen(
                                  context: context,
                                  builder: (context) => const RegisterPage(),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  rewardsCard(PointsDetailsModel points, UserModel user) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
      padding: EdgeInsets.only(
          top: 25.0,
          left: 15.0,
          right: 15.0,
          bottom: user.uid == null ? 25.0 : 0.0),
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
        itemCount: points.rewardsAmounts.length,
        separatorBuilder: (context, index) => Spacing().vertical(10),
        itemBuilder: (context, index) => rewardsAmountTile(points, index),
      ),
    );
  }

  rewardsAmountTile(PointsDetailsModel points, int index) {
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
              '${points.rewardsAmounts[index]['amount']}',
              style: const TextStyle(fontSize: 22, color: Colors.white),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        title: Text(
          '${points.rewardsAmounts[index]['description']}',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
