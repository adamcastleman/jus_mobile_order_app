import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/membership_details_provider_widget.dart';

class MembershipTermsOfServicePage extends StatelessWidget {
  const MembershipTermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MembershipDetailsProviderWidget(
      builder: (membershipDetails) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               const Padding(
                  padding:  EdgeInsets.only(bottom: 8.0),
                  child:  Text(
                    'Membership Terms of Service',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
               Spacing.vertical(25),
                Flexible(
                  child: Html(data: membershipDetails.termsOfService),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
