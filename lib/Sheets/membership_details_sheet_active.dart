import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/member_stats_provider_widget.dart';
import 'package:jus_mobile_order_app/Sheets/cancel_membership_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_small.dart';

class ActiveMembershipDetailsSheet extends StatelessWidget {
  const ActiveMembershipDetailsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List transactionData = [
      {'date': '12/04/2022', 'type': 'Renew', 'amount': '\$14.95'},
      {'date': '11/04/2022', 'type': 'Renew', 'amount': '\$14.95'},
      {'date': '10/04/2022', 'type': 'Renew', 'amount': '\$14.95'},
      {'date': '09/04/2022', 'type': 'Renew', 'amount': '\$14.95'},
      {'date': '08/04/2022', 'type': 'Renew', 'amount': '\$14.95'},
      {'date': '07/04/2022', 'type': 'Renew', 'amount': '\$14.95'},
      {'date': '06/04/2022', 'type': 'Created', 'amount': '\$14.95'},
    ];
    return MemberStatsProviderWidget(
      builder: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Membership',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Spacing().vertical(15),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.red[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status: Paused',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 100,
                    child: SmallElevatedButton(
                      buttonText: 'Renew',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Spacing().vertical(15),
            SizedBox(
              height: 200,
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            CupertinoIcons.money_dollar_circle,
                            size: 60,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Began:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '06/04/2022',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Paused:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '01/14/2023',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            CupertinoIcons.chart_bar_circle,
                            size: 60,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Saved:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '\$${(stats.totalSaved! / 100).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bonus Points:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${stats.bonusPoints}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                itemCount: transactionData.length,
                separatorBuilder: (context, index) => JusDivider().thin(),
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(index == transactionData.length - 1
                      ? CupertinoIcons.creditcard
                      : CupertinoIcons.refresh),
                  title: Text(
                    transactionData[index]['date'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    transactionData[index]['type'],
                  ),
                  trailing: Text(
                    transactionData[index]['amount'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Spacing().vertical(30),
            Center(
              child: LargeElevatedButton(
                buttonText: 'Cancel Membership',
                onPressed: () {
                  ModalBottomSheet().partScreen(
                    enableDrag: true,
                    isScrollControlled: true,
                    isDismissible: true,
                    context: context,
                    builder: (context) =>
                        const CancelMembershipConfirmationSheet(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
